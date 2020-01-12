@echo off

set AppName=keygen
set ResName=rsrc
set Packer=.\packer\upx.exe


\masm32\bin\ml /c /coff %AppName%.asm


if exist %ResName%.rc	\masm32\bin\rc %ResName%.rc
if exist %ResName%.res	\masm32\bin\cvtres /machine:ix86 %ResName%.res


\masm32\bin\Link /SUBSYSTEM:WINDOWS %AppName%.obj %ResName%.obj

if exist %AppName%.obj	del %AppName%.obj
if exist %ResName%.res	del %ResName%.res
if exist %ResName%.obj	del %ResName%.obj

if exist "%AppName%.exe" %Packer% -9 %AppName%.exe

pause

