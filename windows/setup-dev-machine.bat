@echo off

echo Ensure that your cmd.exe runs as Administrator
echo .
pause

echo Install chocolatey, then other tools
echo .
echo Browse https://chocolatey.org/packages for packages
echo .
pause
echo .

powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco feature enable -n=allowGlobalConfirmation

echo Now chocolatey should be ready and we can go ahead
echo .
pause

choco install git.install -y --params "/GitAndUnixToolsOnPath"
choco install tortoisegit
choco install firefox
choco install googlechrome
choco install notepadplusplus
choco install putty.install
choco install winscp.install
choco install jdk8
choco install openjdk11
choco install openjdk
choco install 7zip
choco install nvs
choco install docker-for-windows 
choco install totalcommander
choco install intellijidea-ultimate
choco install google-drive-file-stream
choco install toggl
choco install maven
choco install winrar
choco install wireshark
choco install mysql.workbench
choco install mremoteng
choco install gnupg

echo .
pause
