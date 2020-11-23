@echo off
pushd "%~dp0" && net sess 1>nul 2>nul || (powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c "%~nx0" %*'" >nul 2>nul & exit /b 1)

call :Locale1033
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO call :Locale%%a

echo This will disable all the suspicious services from MS.

:loop
set /p _ANSWER=%RESTOREPOINT%? (Yes/No)
if /i "%_ANSWER%" EQU "y" goto continue2rp
if /i "%_ANSWER%" EQU "n" goto continue_no_rp
goto :loop

:continue2rp
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Antispy %DATE% %TIME%' -RestorePointType MODIFY_SETTINGS"

:continue_no_rp
set _ANSWER=

call :RemoveService AarSvc "Runtime for activating conversational agent applications"
call :RemoveService DevicePickerUserSvc "This user service is used for managing the Miracast, DLNA, and DIAL UI"
call :RemoveService DeviceAssociationBrokerSvc "Enables apps to pair devices"
call :RemoveService CredentialEnrollmentManagerUserSvc "Credential Enrollment Manager"
call :RemoveService cbdhsvc "This user service is used for Clipboard scenarios"
call :RemoveService CaptureService "Enables optional screen capture functionality for applications that call the Windows.Graphics.Capture API."
call :RemoveService BluetoothUserService "The Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session."
call :RemoveService BcastDVRUserService "This user service is used for Game Recordings and Live Broadcasts"
call :RemoveService PrintWorkflowUserSvc "Provides support for Print Workflow applications. If you turn off this service, you may not be able to print successfully."
call :RemoveService UdkUserSvc "Shell components service"

call :RemoveService DiagTrack
rem call :RemoveService dmwappushservice "Routes Wireless Application Protocol (WAP) Push messages received by the device and synchronizes Device Management sessions"
call :RemoveService WerSvc "Allows errors to be reported when programs stop working or responding and allows existing solutions to be delivered. Also allows logs to be generated for diagnostic and repair services. If this service is stopped, error reporting might not work correctly and results of diagnostic services and repairs might not be displayed."
call :RemoveService OneSyncSvc "This service synchronizes mail, contacts, calendar and various other user data. Mail and other applications dependent on this functionality will not work properly when this service is not running."
call :RemoveService PimIndexMaintenanceSvc "Indexes contact data for fast contact searching. If you stop or disable this service, contacts might be missing from your search results."
call :RemoveService UnistoreSvc "Handles storage of structured user data, including contact info, calendars, messages, and other content. If you stop or disable this service, apps that use this data might not work correctly."
call :RemoveService UserDataSvc "Provides apps access to structured user data, including contact info, calendars, messages, and other content. If you stop or disable this service, apps that use this data might not work correctly."
call :RemoveService MessagingService "Service supporting text messaging and related functionality."
rem call :RemoveService WpnUserService "This service hosts Windows notification platform which provides support for local and push notifications. Supported notifications are tile, toast and raw."
rem call :RemoveService DevicesFlowUserSvc "Allows ConnectUX and PC Settings to Connect and Pair with WiFi displays and Bluetooth devices."
call :RemoveService CDPUserSvc "This user service is used for Connected Devices Platform scenarios"

:End
echo All done. Restart now.
pause
goto :EOF

:RemoveService
echo.===== %1 ======
echo Description: %2

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
rem if /i "%_ANSWER%" EQU "a" pause
goto :EOF

:DeleteService
if /i "%_ANSWER%" EQU "a" goto continue
set /p _ANSWER=%DISABLE%? (Yes/No/All)
if /i "%_ANSWER%" EQU "y" goto continue
if /i "%_ANSWER%" EQU "n" goto :EOF
goto :DeleteService

:continue
for /f "tokens=*" %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /k /f "%1" ^| find /i "%1"') do (
	set /a found+=1
	set str=%%I
	if "%str%" equ "" (
		rem sc delete %1 > nul
		echo.%BLOCKED% %1 %INREGISTRY%
		reg add "%%I" /v "Start" /t REG_DWORD /d 4 /f
	) else (
		for /f "usebackq delims=\ tokens=5*" %%a in (`echo %%I`) do (
			rem sc delete %%a > nul
			echo.%BLOCKED% %%a %INREGISTRY%
			reg add "%%I" /v "Start" /t REG_DWORD /d 4 /f
		)
	)
)
echo.%SERVICE% %1 %PROCESSED%...
goto :EOF

:Locale1033
set RESTOREPOINT=Create Restore Point
set DISABLE=Disable it?
set RUNNING=RUNNING
set STOPPED=STOPPED
set ABSENT=NOT FOUND
set ABORT=ACCESS DENIED
set SERVICE=SERVICE
set PROCESSED=IS PROCESSED
set NOT=NOT
set ATTEMPTTODELETE=ATTEMPT TO DELETE
set BLOCKED=BLOCKED
set INREGISTRY=IN REGISTRY
goto :EOF

:Locale1049
chcp 1251 > nul
	set RESTOREPOINT=Ñîçäàòü òî÷êó âîññòàíîâëåíèÿ ñèñòåìû
	set DISABLE=Îòêëþ÷èòü
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