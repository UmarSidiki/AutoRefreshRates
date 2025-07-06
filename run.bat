@echo off
setlocal enabledelayedexpansion

REM Define ANSI escape codes for colors and styles
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RESET=%ESC%[0m"
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "BLUE=%ESC%[94m"
set "MAGENTA=%ESC%[95m"
set "CYAN=%ESC%[96m"
set "WHITE=%ESC%[97m"
set "BOLD=%ESC%[1m"
set "UNDERLINE=%ESC%[4m"
set "BG_BLACK=%ESC%[40m"
set "BG_GREEN=%ESC%[42m"

REM ===============================================
REM Auto Refresh Rate Manager - Installer
REM 
REM Automatically adjusts display refresh rate based on power state
REM - On Battery: Lowest available refresh rate (power saving)
REM - On AC Power: Highest available refresh rate (performance)
REM 
REM Version: 1.0
REM Compatibility: Windows 10/11
REM Developer: https://github.com/UmarSidiki
REM ===============================================

echo %BOLD%%CYAN%===============================================%RESET%
echo %BOLD%%CYAN%Auto Refresh Rate Manager - Installer%RESET%
echo %BOLD%%CYAN%Developed by: https://github.com/UmarSidiki%RESET%
echo %BOLD%%CYAN%===============================================%RESET%
echo.

REM Check for admin privileges and exit if not admin
echo %YELLOW%Checking administrator privileges...%RESET%
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo %RED%%BOLD%ERROR: This script requires administrator privileges!%RESET%
    echo %RED%Please right-click on the script and select "Run as administrator".%RESET%
    echo.
    echo %YELLOW%Press any key to exit...%RESET%
    pause > nul
    exit /B 1
) else ( 
    echo %GREEN%%BOLD%SUCCESS: Running with administrator privileges!%RESET%
)

REM Continue with admin privileges
pushd "%CD%"
CD /D "%~dp0"

REM Get the current directory
set "CURRENT_DIR=%~dp0"

REM Define paths
set "TEMPLATE_DIR=%CURRENT_DIR%template"
set "LIB_DIR=%CURRENT_DIR%lib"
set "TEMPLATE_ENC=%TEMPLATE_DIR%\template.enc"
set "TEMPLATE_XML=%TEMPLATE_DIR%\temp_decoded.xml"
set "OUTPUT_XML=%CURRENT_DIR%Auto Refresh Rate.xml"

REM Check if encrypted template exists
if not exist "%TEMPLATE_ENC%" (
    echo %RED%%BOLD%Error: Encrypted template file not found at "%TEMPLATE_ENC%"%RESET%
    exit /b 1
)

REM Decrypt the template file
echo %CYAN%Decrypting template...%RESET%
powershell -Command "[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String((Get-Content '%TEMPLATE_ENC%' -Raw))) | Out-File '%TEMPLATE_XML%' -Encoding UTF8"

REM Check if decryption was successful
if not exist "%TEMPLATE_XML%" (
    echo %RED%%BOLD%Error: Failed to decrypt template file%RESET%
    exit /b 1
)

REM Find VBS script in lib directory
echo %CYAN%Searching for VBS script...%RESET%
set "VBS_FOUND="
for %%F in ("%LIB_DIR%\*.vbs") do (
    set "VBS_PATH=%%~fF"
    set "VBS_FOUND=1"
    echo %GREEN%Found VBS script: %YELLOW%"!VBS_PATH!"%RESET%
    goto :foundvbs
)

:foundvbs
if not defined VBS_FOUND (
    echo %RED%%BOLD%Error: No VBS script found in "%LIB_DIR%"%RESET%
    echo %RED%Please place your VBS script in the lib folder.%RESET%
    exit /b 1
)

REM Replace placeholders in template and create new XML
echo %CYAN%Creating task XML with proper paths...%RESET%
powershell -Command "(Get-Content '%TEMPLATE_XML%' -Raw) -replace '##VBS_PATH##', '%VBS_PATH%' | Out-File '%OUTPUT_XML%' -Encoding Unicode"

echo %GREEN%%BOLD%Task XML created successfully at:%RESET%
echo %YELLOW%%OUTPUT_XML%%RESET%

REM Ask if user wants to import the task
echo.
echo %BOLD%%UNDERLINE%Final Step:%RESET%
set /p IMPORT_TASK="%WHITE%Do you want to import the task into Task Scheduler? (Y/N): %RESET%"
if /i "%IMPORT_TASK%"=="Y" (
    echo %CYAN%Importing task...%RESET%
    schtasks /create /tn "Auto Refresh Rate" /xml "%OUTPUT_XML%" /f
    if errorlevel 1 (
        echo Failed to import task.
    ) else (
        echo Task imported successfully.
        
        REM Delete the XML file after successful import
        if exist "%OUTPUT_XML%" (
            del "%OUTPUT_XML%"
            echo Generated XML file removed.
        )
    )
)

echo.
echo %BG_GREEN%%BLACK%%BOLD% Done! %RESET%

REM Clean up temporary decrypted template
if exist "%TEMPLATE_XML%" (
    del "%TEMPLATE_XML%"
)

echo.
echo %YELLOW%Press any key to exit...%RESET%
pause > nul
if exist "%TEMPLATE_XML%" (
    del "%TEMPLATE_XML%"
)

echo.
echo %YELLOW%Press any key to exit...%RESET%
pause > nul
