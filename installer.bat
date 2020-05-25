@echo off
title Mike's EZ Installer
color f5

:installgit
title Installing Prerequisites
echo Installing Prerequisites
echo -----------------------------------------
Echo Installing Git...
IF EXIST "C:\Program Files\Git\git-bash.exe" (goto start) ELSE ("..\Installer\Files\setup files\Git-2.26.2-64-bit.exe" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere")
Echo Installation Complete..
Echo Installing Java Runtime Environment...
IF EXIST "C:\Program Files\AdoptOpenJDK\jre-8.0.252.09-hotspot\release" (goto start) ELSE ("..\Installer\Files\setup files\Latest Java Version.exe")
cls

:start
title Starting Installation
rmdir /Q /S ..\Installer\Files\mods
rmdir /Q /S ..\Installer\Files\updates
cls
set /p choice=Do you already have minecraft forge installed for 1.15.2? (y/n) : 
if '%choice%'=='y' goto freshinstall
if '%choice%'=='Y' goto freshinstall
if '%choice%'=='n' goto forge
if '%choice%'=='N' goto forge

:forge
title Installing Minecraft Forge
curl https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.15.2-31.1.77/forge-1.15.2-31.1.77-installer.jar --output ..\Installer\forge-1.15.2-31.1.77-installer.jar
java -jar forge-1.15.2-31.1.77-installer.jar
del /f /q "..\Installer\forge-1.15.2-31.1.77-installer.jar"
del /f /q "..\Installer\forge-1.15.2-31.1.77-installer.jar.log"
del /f /q '..\Installer\installer.log"
goto freshinstall


:freshinstall
cls
set /p choice=Fresh install or Upgrading? (f / u) : 
if '%choice%'=='f' goto freshyes
if '%choice%'=='F' goto freshyes
if '%choice%'=='u' goto step3
if '%choice%'=='U' goto step3

:freshyes
title Downloading Mods
rmdir /Q /S %appdata%\.minecraft\mods
goto step2

:step2
git clone https://github.com/circlol/mods.git Files/mods
del ..\Installer\Files\mods\.gitattributes
del ..\Installer\Files\mods\README.md
git clone https://github.com/circlol/updates.git Files/updates
title Installing mods
mkdir %appdata%\.minecraft\mods\
copy /y ..\Installer\Files\mods\ %appdata%\.minecraft\mods\
copy ..\Installer\Files\updates\ %appdata%\.minecraft\mods\
goto step4

:step4
title Finishing Up.
copy ..\Installer\Files\options\options.txt %appdata%\.minecraft\
copy ..\Installer\Files\options\optionsof.txt %appdata%\.minecraft
copy ..\Installer\Files\options\optionsshaders.txt %appdata%\.minecraft
copy ..\Installer\Files\servers.dat %appdata%\.minecraft\
goto cleanup


:upgrading
title Upgrading mods
git clone https://github.com/circlol/updates.git Files/updates
copy ..\Installer\Files\updates\ %appdata%\.minecraft\mods\
goto cleanup

:cleanup
rmdir /Q /S ..\Installer\Files\mods
rmdir /Q /S ..\Installer\Files\updates
del /f /q "..\Installer\Files\Installer.bat"
del /f /q "..\Installer\Files\servers.dat"


:succeeded
title Successful! Thank you for using Mike's EZ Installer
cls
color 4f
echo Good job! We're finished here.
echo.
echo.
echo Everything succeeded. Open Minecraft and select the Forge instance and run.
echo.
echo.
echo Once your game finishes loading, select multiplayer to join 'Mike Wazowski'.
pause
goto end
:end
exit