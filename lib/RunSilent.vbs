Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
' Get the directory where this VBS script is located
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
powershellPath = scriptDir & "\AutoSetRefreshRate.ps1"
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File """ & powershellPath & """", 0, False
