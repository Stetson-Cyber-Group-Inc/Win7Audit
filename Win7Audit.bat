@ECHO OFF
CLS
echo We need Admin Rights, I'll Check that for you...
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
echo.
echo Nope, Not an Admin, I'll Fix that...
echo.
echo Click on Yes/OK if the UAC box pops up... thanks 

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO args = "ELEV " >> "%temp%\OEgetPrivileges.vbs"
ECHO For Each strArg in WScript.Arguments >> "%temp%\OEgetPrivileges.vbs"
ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
ECHO Next >> "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" %*
exit /B

:gotPrivileges
echo.
echo Yay, we have Admin rights, moving along... 
if '%1'=='ELEV' shift /1
setlocal & pushd .
cd /d %~dp0


color 0A
set sdir=%~dp0

if not exist "C:\Temp\" mkdir C:\Temp
echo.
echo [+] Getting System Information.....
echo [+] Please Wait.....
echo.
msinfo32 /nfo c:\temp\%computername%-SysInfo.nfo
echo [+] Copying Report.....
echo f | xcopy /s /f c:\temp\%computername%-SysInfo.nfo %sdir%\%computername%-SysInfo.nfo
echo [+] Done!.....
del c:\temp\%computername%-SysInfo.nfo /F