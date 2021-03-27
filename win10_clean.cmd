@echo off
echo This script will cleanup the Windows folder by DISM tool. This will wipe out all old version of packages and Service Pack rollback information. 
echo You will not be able to rollback or older version of Windows 10. 
echo You may also consider to use PatchCleaner tool (google for it) to clean unnecessary files in C:\Windows\Installer (used by third party software).
echo If you run this to save disk space, it is assumed that you have already used the built-in Disk Cleanup function. If not, please use it first.
echo Press ane key to start or Ctrl+C to cancel...
pause > nul
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
Dism.exe /online /Cleanup-Image /SPSuperseded
