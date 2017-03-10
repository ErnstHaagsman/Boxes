@echo off
echo Starting...
vagrant resume | find /i "booted and ready"

IF %ERRORLEVEL% EQU 0 (
    echo Done, you can start!
    timeout /t 2
) else (
    echo Vagrant resume didn't work, recreating
    vagrant destroy -f
    vagrant up
)