@echo off
setlocal enabledelayedexpansion

REM ===============================================
REM Auto Refresh Rate Manager - Uninstaller
REM 
REM Removes the scheduled task and cleans up generated files
REM 
REM Version: 1.0
REM Compatibility: Windows 10/11
REM ===============================================

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

echo ===============================================
echo Auto Refresh Rate Manager - Uninstaller
echo ===============================================
echo.

REM Check if the scheduled task exists
echo Checking for existing scheduled task...
schtasks /query /tn "Auto Refresh Rate" >nul 2>&1
if errorlevel 1 (
    echo No scheduled task found with name "Auto Refresh Rate"
) else (
    echo Found scheduled task "Auto Refresh Rate"
    echo.
    set /p REMOVE_TASK="Do you want to remove the scheduled task? (Y/N): "
    if /i "!REMOVE_TASK!"=="Y" (
        echo Removing scheduled task...
        schtasks /delete /tn "Auto Refresh Rate" /f
        if errorlevel 1 (
            echo Failed to remove scheduled task.
        ) else (
            echo Scheduled task removed successfully.
        )
    ) else (
        echo Scheduled task was not removed.
    )
)

echo.
REM Check for generated XML file
set "CURRENT_DIR=%~dp0"
set "OUTPUT_XML=%CURRENT_DIR%Auto Refresh Rate.xml"

if exist "%OUTPUT_XML%" (
    echo Found generated XML file: Auto Refresh Rate.xml
    set /p REMOVE_XML="Do you want to remove the generated XML file? (Y/N): "
    if /i "!REMOVE_XML!"=="Y" (
        del "%OUTPUT_XML%"
        if exist "%OUTPUT_XML%" (
            echo Failed to remove XML file.
        ) else (
            echo XML file removed successfully.
        )
    ) else (
        echo XML file was not removed.
    )
) else (
    echo No generated XML file found.
)

echo.
echo ===============================================
echo Uninstall process completed.
echo ===============================================
echo.
echo Note: The following files were not removed:
echo - lib\AutoSetRefreshRate.ps1
echo - lib\RunSilent.vbs
echo - template\template.enc
echo - run.bat
echo - uninstall.bat
echo - README.md
echo.
echo If you want to completely remove the application,
echo you can manually delete the entire folder.
echo.
pause
