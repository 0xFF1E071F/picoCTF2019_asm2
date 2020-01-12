@echo off

rem Keygen template - Make batch
rem ============================================================================
rem Author : Canterwood <canterwood@altern.org>
rem Website: http://kickme.to/canterwood
rem IDE    : MASM32 8
rem ============================================================================
rem 03.01.2004

rem Compile the ressources
\masm32\bin\rc         /v rsrc.rc
\masm32\bin\cvtres.exe /machine:ix86 rsrc.res

rem Compile the code
\masm32\bin\ml.exe /c /coff keygen.asm

rem Link the object files and produce the executable
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /OUT:keygen.exe keygen.obj rsrc.obj

rem Delete the temporary files
if exist *.obj del *.obj
if exist *.res del *.res

pause