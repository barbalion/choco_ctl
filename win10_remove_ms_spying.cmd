@echo off
pushd "%~dp0" && net sess 1>nul 2>nul || (powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c "%~nx0" %*'" >nul 2>nul & exit /b 1)

call :Locale1033
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO call :Locale%%a

call :RemoveService AarSvc
call :RemoveService DevicePickerUserSvc
call :RemoveService DeviceAssociationBrokerSvc
call :RemoveService CredentialEnrollmentManagerUserSvc
call :RemoveService cbdhsvc
call :RemoveService CaptureService
call :RemoveService BluetoothUserService
call :RemoveService BcastDVRUserService
call :RemoveService PrintWorkflowUserSvc
call :RemoveService UdkUserSvc

call :RemoveService DiagTrack
call :RemoveService dmwappushservice
call :RemoveService WerSvc
call :RemoveService OneSyncSvc
call :RemoveService PimIndexMaintenanceSvc
call :RemoveService UnistoreSvc
call :RemoveService UserDataSvc
call :RemoveService MessagingService
call :RemoveService WpnUserService
call :RemoveService DevicesFlowUserSvc
call :RemoveService CDPUserSvc
:End
pause
goto :EOF

:RemoveService
echo.=== %1 ===
echo.%ATTEMPTTODELETE% %SERVICE% %1
for /f "tokens=1,4" %%x in ('sc query %1') do ( 
	if "%%x"=="STATE" ( 
		if "%%y"=="RUNNING" (
			echo.%SERVICE% %1 %RUNNING%
		) 
		if "%%y"=="STOPPED" (
			echo.%SERVICE% %1 %STOPPED%
		)
		call :DeleteService %1
	) else (
		if "%%x"=="‘®áâ®ï­¨¥" ( 
			if "%%y"=="RUNNING" (
				echo.%SERVICE% %1 %RUNNING%
			)
			if "%%y"=="STOPPED" (
				echo.%SERVICE% %1 %STOPPED%
			)
			call :DeleteService %1
		)
	)
	if "%%x"=="[SC]" ( 
		if "%%y"=="1060:" (
			echo.%SERVICE% %1 %NOT% %PROCESSED% [%ABSENT%]
		)
		if "%%y"=="5:" (
			echo.%SERVICE% %1 %NOT% %PROCESSED% [%ABORT%]
		)
	) 
)
echo.
goto :EOF

:DeleteService
for /f "tokens=*" %%I in ('reg query "HKLM\SYSTEM\ControlSet001\Services" /k /f "%1" ^| find /i "%1"') do (
	set /a found+=1
	set str=%%I
	if "%str%" equ "" (
		sc delete %1 > nul
		echo.%BLOCKED% %1 %INREGISTRY%
		reg add "%%I" /v "Start" /t REG_DWORD /d 4 /f
	) else (
		for /f "usebackq delims=\ tokens=5*" %%a in (`echo %%I`) do (
			sc delete %%a > nul
			echo.%BLOCKED% %%a %INREGISTRY%
			reg add "%%I" /v "Start" /t REG_DWORD /d 4 /f
		)
	)
)
echo.%SERVICE% %1 %PROCESSED%...
goto :EOF

:Locale1033
set RUNNING=RUNNING
set STOPPED=STOPPED
set ABSENT=NOT FOUND
set ABORT=ACCESS DENIED
set SERVICE=SERVICE
set PROCESSED=PROCESSED
set NOT=NOT
set ATTEMPTTODELETE=ATTEMPT TO DELETE
set BLOCKED=BLOCKED
set INREGISTRY=IN REGISTRY
goto :EOF

:Locale1049
chcp 1251 > nul
	set RUNNING=ÂÛÏÎËÍßÅÒÑß
	set STOPPED=ÎÑÒÀÍÎÂËÅÍ
	set ABSENT=ÎÒÑÓÒÑÒÂÓÅÒ
	set ABORT=ÎÒÊÀÇÀÍÎ Â ÄÎÑÒÓÏÅ
	set SERVICE=ÑÅÐÂÈÑ
	set PROCESSED=ÎÁÐÀÁÎÒÀÍ
	set NOT=ÍÅ
	set ATTEMPTTODELETE=ÏÎÏÛÒÊÀ ÓÄÀËÈÒÜ
	set BLOCKED=ÁËÎÊÈÐÓÅÌ ÇÀÏÓÑÊ ÑÅÐÂÈÑÀ
	set INREGISTRY=Â ÐÅÅÑÒÐÅ
chcp 866 > nul
goto :EOF