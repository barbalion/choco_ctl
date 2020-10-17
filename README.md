# choco_ctl
This is a helper &amp; automation tool for [Chocolatey](https://chocolatey.org/).

## Motivation
The main purpose of the tool is to simplify migration from one computer to another. I created it when I bought a new laptop and I was too lazy to install all the applications I have on the new computer.

## Usage
1. Download [choco_ctl.cmd](https://github.com/barbalion/choco_ctl/raw/main/choco_ctl.cmd) to any local folder. 
1. Run `choco list` on your reference machine (assuming you have some packages installed by Chocolatey there) to save currently installed packages into `choco.list` file. You may then transfer `choco.list` to destination (along with the sctipt on a flash-drive, let's say).
1. Run `choco_ctl install` to automatically install Chocolatey on the destination host. You may also run just `choco_ctl` without parameters and it will prompt to install missing Chocolatey.
1. Run `choco_ctl` on the destination computer and answer the question to manage the list of packages you need to install (you can choose one-by-one, or just approve all of them).

## Other Tools
`wifi_backup.cmd` and `wifi_restore.cmd` are simple scripts to transfer your Wifi Settings across machines. It is also a good way to see your WiFi passwords decrypted. Be carefull if your WiFi setting is a sesitive information!

`win10_remove_ms_spying.cmd` is a simple script to remove telemetry (alias 'spying') functionality of Windows 10.

`cred_manager.cmd` is a shourcut for built-in Credential Manager of Windows. Among other things, it allows you to export/import your credentials (User Names and Passwords) stored in Windows.

`win10_system_settings_fix.cmd` is set of command trying to fix System Settings failerus to start. (aka "open/flashes and immediatly closes").

`wu10.diagcab` is a standard MS launcher of Windows built-in troubleshooters.
