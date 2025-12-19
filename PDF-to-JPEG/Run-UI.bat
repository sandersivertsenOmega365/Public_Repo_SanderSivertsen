@echo off
setlocal
REM Launch the simple GUI for PDF -> JPEG
set SCRIPT=%~dp0Convert-PdfToJpeg.GUI.ps1
set LOG=%~dp0last-run-ui.log

if not exist "%SCRIPT%" (
  echo Could not find Convert-PdfToJpeg.GUI.ps1 next to this file.
  pause
  exit /b 1
)

"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -STA -File "%SCRIPT%" > "%LOG%" 2>&1
set ERR=%ERRORLEVEL%
if not %ERR%==0 (
  echo Something went wrong. See details below:
  type "%LOG%"
)
pause
endlocal
