@echo off
pushd "%~dp0" && net sess 1>nul 2>nul || (powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c "%~nx0" %*'" >nul 2>nul & exit /b 1)

@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}"

sfc /scannow
goto :EOF