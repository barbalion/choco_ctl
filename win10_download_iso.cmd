rem @echo off
set _EDITION=Enterprise
set _LOCALE=en-US
set _ARCH=x64

for %%f in ("%~dp0MediaCreationTool*.exe") do set _TOOLPATH=%%f
if not defined _TOOLPATH (
  echo MediaCreationTool*.exe is not found. Please download it and start the script again. Prees any key to exit, the download link will open.
  pause
  start https://go.microsoft.com/fwlink/?LinkId=691209
  exit /b 1
)

cd /d "%~dp0"
start %_TOOLPATH% /Eula Accept /Retail /MediaLangCode %_LOCALE% /MediaArch %_ARCH% /MediaEdition %_EDITION%
