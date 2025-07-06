@echo off
setlocal enabledelayedexpansion

REM ===============================================
REM Auto Refresh Rate Manager - Installer
REM 
REM Automatically adjusts display refresh rate based on power state
REM - On Battery: 60Hz (battery saving)
REM - On AC Power: 144Hz (performance)
REM 
REM Version: 1.0
REM Compatibility: Windows 10/11
REM ===============================================

echo ===============================================
echo Auto Refresh Rate Manager - Installer
echo ===============================================
echo.

REM Check for admin privileges and request elevation if needed
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
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
    echo Error: Encrypted template file not found at "%TEMPLATE_ENC%"
    exit /b 1
)

REM Decrypt the template file
echo Decrypting template...
powershell -Command "[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String((Get-Content '%TEMPLATE_ENC%' -Raw))) | Out-File '%TEMPLATE_XML%' -Encoding UTF8"

REM Check if decryption was successful
if not exist "%TEMPLATE_XML%" (
    echo Error: Failed to decrypt template file
    exit /b 1
)

REM Find VBS script in lib directory
set "VBS_FOUND="
for %%F in ("%LIB_DIR%\*.vbs") do (
    set "VBS_PATH=%%~fF"
    set "VBS_FOUND=1"
    echo Found VBS script: "!VBS_PATH!"
    goto :foundvbs
)

:foundvbs
if not defined VBS_FOUND (
    echo Error: No VBS script found in "%LIB_DIR%"
    echo Please place your VBS script in the lib folder.
    exit /b 1
)

REM Replace placeholders in template and create new XML
echo Creating task XML with proper paths...
powershell -Command "(Get-Content '%TEMPLATE_XML%' -Raw) -replace '##VBS_PATH##', '%VBS_PATH%' | Out-File '%OUTPUT_XML%' -Encoding Unicode"

echo Task XML created successfully at:
echo %OUTPUT_XML%

REM Ask if user wants to import the task
echo.
set /p IMPORT_TASK="Do you want to import the task into Task Scheduler? (Y/N): "
if /i "%IMPORT_TASK%"=="Y" (
    echo Importing task...
    schtasks /create /tn "Auto Refresh Rate" /xml "%OUTPUT_XML%" /f
    if errorlevel 1 (
        echo Failed to import task.
    ) else (
        echo Task imported successfully.
    )
)

echo.
echo Done!

REM Clean up temporary decrypted template
if exist "%TEMPLATE_XML%" (
    del "%TEMPLATE_XML%"
)

pause
