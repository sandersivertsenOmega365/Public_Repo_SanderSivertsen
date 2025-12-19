@echo off
REM Super-simple launcher for non-technical users
REM Opens PowerShell and runs the converter with execution policy bypass
powershell -ExecutionPolicy Bypass -File "%~dp0Convert-PdfToJpeg.ps1"
