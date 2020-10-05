# choco_ctl
This is a helper &amp; automation tool for [Chocolatey](https://chocolatey.org/).

## Motivation
The main purpose of the tool is to simplify migration from one computer to another. I created it when I bought a new laptop and I was too lazy to install all the applications I have on the new computer.

## Usage
1. Run `choco list` on your reference machine (assuming you have some packages installed by Chocolatey there) to save currently installed packages into `choco.list` file. You may then transfer `choco.list` to destination (along with the sctipt on a flash-drive, let's say).
1. Run `choco_ctl install` to automatically install Chocolatey on the destination host. You may also run just `choco_ctl` without parameters and it will prompt to install missing Chocolatey.
1. Run `choco_ctl` on the destination computer and answer the question to manage the list of packages you need to install (you can choose one-by-one, or just approve all of them).
