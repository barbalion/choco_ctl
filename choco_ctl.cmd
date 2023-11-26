@echo off
pushd "%~dp0" && net sess 1>nul 2>nul || (powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c \"%~f0\" %*'" >nul 2>nul & exit /b 1)

set LIST_FILE="%~dp0choco.list"
set TMPLIST_FILE="%TEMP%\choco.list.tmp"
set CHOSENLIST_FILE="%TEMP%\choco.list_chosen.tmp"
set IGNORE_LIST="%~dp0choco.ignore.list"

if not %1a == a goto %*

choco -v >nul 2>nul
if %errorlevel% NEQ 0 (
  echo Chocolatey not found. Press any key to install it or CTRL+C to cancel.
  pause
  goto install
)

if not exist %LIST_FILE% (
  echo File %LIST_FILE% does not exist. Run "%~nx0 list" on reference machine first.
  exit /b 1
)
type nul > %TMPLIST_FILE%
type nul > %CHOSENLIST_FILE%
for /f "skip=1 tokens=1" %%i in ('type %LIST_FILE%') do echo %%i z >> %TMPLIST_FILE%
if exist %IGNORE_LIST% for /f "tokens=1" %%i in ('type %IGNORE_LIST%') do echo %%i i >> %TMPLIST_FILE%
for /f "tokens=1" %%i in ('choco list -lr --idonly') do echo %%i i >> %TMPLIST_FILE%
for /f "tokens=1,2" %%i in ('sort %TMPLIST_FILE%') do (
  if %%j == i set _PREVPKG=%%i
  if %%j == z call :check %%i
)
for /f "tokens=1" %%i in ('type %CHOSENLIST_FILE%') do call :do_install %%i
call :clean
goto :EOF

:clean
del %TMPLIST_FILE%
del %CHOSENLIST_FILE%
goto :EOF

:list 
choco list -lr --idonly > %LIST_FILE%
goto :EOF

:check
set _PKG=%1
if /i "%_PREVPKG%" == "%_PKG%" (
  echo "%_PKG%" is already installed.
  goto :EOF
)
if /i "%_CHOICE%" == "a" goto install_pkg 
set /p _CHOICE=Install "%_PKG%" (Yes/igNore/Install now/More info/All/Skip/Quit)? 
if /i "%_CHOICE%" == "y" goto install_pkg 
if /i "%_CHOICE%" == "i" goto do_install
if /i "%_CHOICE%" == "s" goto :EOF
if /i "%_CHOICE%" == "m" choco info %_PKG%
if /i "%_CHOICE%" == "q" (
  call :clean
  exit
)
if /i "%_CHOICE%" == "n" (
  echo %_PKG% >> %IGNORE_LIST%
  goto :EOF 
)
goto check

:install_pkg
echo %1 >> %CHOSENLIST_FILE%
goto :EOF

:do_install
choco install --ignore-checksums %1
goto :EOF

:install
echo Installing Chocolatey. Please wait...
choco -v 1>nul 2>nul 
if %errorlevel% EQU 0 (
  echo Chocolatey is already installed. Press any key to run installation script or CTRL+C to cancel.
  pause
)
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
start "Choco" /min "%comspec%" /c "choco feature enable -n allowGlobalConfirmation"
echo Press any key to exit. Re-run the script to manage your packeges now.
pause
goto :EOF
