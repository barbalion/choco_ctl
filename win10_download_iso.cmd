@echo off
set _TOOLPATH=MediaCreationTool20H2.exe
set _EDITION=Enterprise
set _LOCALE=en-US

cd /d "%~dp0"
%_TOOLPATH% /Eula Accept /Retail /MediaLangCode %_LOCALE% /MediaArch x64 /MediaEdition %_EDITION%
if errorlevel 1 (
  echo %_TOOLPATH% is not found. Please download it and start the script again. Prees any key to exit, the download link will open.
  pause
  start https://go.microsoft.com/fwlink/?LinkId=691209
)