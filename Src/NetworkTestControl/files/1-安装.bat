::/*****************************************************\
::
::     NetworkTestControl - 1-��װ.bat
::
::     ��Ȩ����(C) 2024 CJH��
::
::     ��װ������
::
::\*****************************************************/
@echo off
::*****************************************************
::��ע�������ͨ����������ע���ֵ���Զ�������
::��������ڸ�ֵ���ʽ��Ч��ʹ��Ĭ�����á�
::1.��������Ƿ�ʱ�ļ��ʱ�䣨����ms�����������1000ms����������ʧ����ʾ����������Ҽ��Խ��Խ��ϵͳ�ڴ棩��
::��HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings ֵTestTimer ����REG_DWORD ��Ĭ��ֵΪ1000��
::2.������糬ʱ�ĵ�ַ����ȷ����ַ��Ч�������������ܲ���ȷ������
::��HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings ֵTestHostName ����REG_SZ ��Ĭ��ֵΪwww.baidu.com��
::3.������������Ƿ�ʱ�ĳ�ʱʱ�䣨����ms������ȷ����ʱʱ�䲻Ҫ����̫�̣�һ��Ϊ2000���¶���������
::��HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings ֵTimeout ����REG_DWORD ��Ĭ��ֵΪ2000��
::4.�����������״̬�ļ��ʱ�䣨����ms�����������1000ms����������ʧ����ʾ����������Ҽ��Խ��Խ��ϵͳ�ڴ棩��
::��HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings ֵNetworkTimer ����REG_DWORD ��Ĭ��ֵΪ1000��
::5.ʹ��Tcpģʽ�����ʱ�������飬Ŀǰ���°汾�Ѿ���Ϊ����VB�Դ���Ping������ʹ�ø�ģʽ�����򴴽����ӹ�����������ӵ�£���0=�رգ�1=��������
::��HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings ֵUseTcpTest ����REG_DWORD ��Ĭ��ֵΪ0��
::6.�ر������⣨�����飬�ر�֮��ֻ���ж�ϵͳ��������״̬�������ж������Ƿ���ʱ����0=���������⣬1=�ر������⣩��
::��HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings ֵDisableNetworkTest ����REG_DWORD ��Ĭ��ֵΪ0��
::*****************************************************
cls
title �������С���߰�װ����
if "%1" == "/noadm" goto main
if "%1" == "/?" goto hlp
fltmc 1>nul 2>nul&& goto main
echo ���ڻ�ȡ����ԱȨ��...
echo.
echo ����ʹ�� %0 /noadm ����Bat��Ȩ�������ֶ��Թ���Ա�������
echo �����ǰ��������ѭ�����֣�����δ�ɹ���ȡ����ԱȨ�ޣ���ע����ǰ�û����������ԣ�
echo Ȼ���Թ���Ա�û��˺����л��ֶ��Թ���Ա������С�
if "%1" == "/mshtaadm" goto mshtaAdmin
if "%1" == "/psadm" goto powershellAdmin
ver | findstr "10\.[0-9]\.[0-9]*" >nul && goto powershellAdmin
:mshtaAdmin
rem ԭ��������mshta����vbscript�ű���bat�ļ���Ȩ
rem ����ʹ����ǰ������ŵ�%~dpnx0����ʾ��ǰ�ű�����ԭ��Ķ��ļ���%~s0���ɿ�
rem ����ʹ��������Net session���ڶ����Ǽ���Ƿ���Ȩ�ɹ��������Ȩʧ������ת��failed��ǩ
rem ����Ч��������Ȩʧ��֮��bat�ļ�����ִ�е�����
::Net session >nul 2>&1 || mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c ""%~dpnx0""","","runas",1)(window.close)&&exit
set parameters=
:parameter
@if not "%~1"=="" ( set parameters=%parameters% %~1& shift /1& goto :parameter)
set parameters="%parameters:~1%"
mshta vbscript:createobject("shell.application").shellexecute("%~dpnx0",%parameters%,"","runas",1)(window.close)&exit
cd /d "%~dp0"
Net session >nul 2>&1 || goto failed
goto main

:powershellAdmin
rem ԭ��������powershell��bat�ļ���Ȩ
rem ����ʹ��������Net session���ڶ����Ǽ���Ƿ���Ȩ�ɹ��������Ȩʧ������ת��failed��ǩ
rem ����Ч��������Ȩʧ��֮��bat�ļ�����ִ�е�����
Net session >nul 2>&1 || powershell start-process \"%0\" -argumentlist \"%1 %2\" -verb runas && exit
Net session >nul 2>&1 || goto failed
goto main

:failed
cls
echo.
echo ��ǰδ�Թ���Ա������С����ֶ��Թ���Ա������б�����
echo.
echo ������ر�... & pause > NUL
goto enda

:hlp
title �������С���߰�װ����
cls
echo.
echo ====================================================
echo               �������С���߰�װ����
echo ====================================================
echo.
echo �����ʹ�����²�����
echo 1-��װ.bat [/noadm ^| /mshtaadm ^| /psadm]
echo.
echo /noadm ����⵽�޹���ԱȨ�������Զ���Ȩ��
echo /mshtaadm ǿ��ʹ��mshta.exe�Զ���Ȩ��
echo /psadm ǿ��ʹ��Powershell.exe�Զ���Ȩ��
echo.
goto enda

:main
cd /d "%~dp0"
title �������С���߰�װ����
cls
echo.
echo ====================================================
echo               �������С���߰�װ����
echo ====================================================
echo.
echo ��Ȩ����(C) 2024 CJH��
echo.
echo ��װǰ����ر�ɱ������Լ���UAC����������UAC�ȼ�Ϊ��ͣ������ڰ�װ����������ѡ��д���Զ�������ᱻ���ص��°�װʧ�ܡ�
echo.
echo �������ʼ��װ... & pause >nul

cls
echo.
echo ====================================================
echo               �������С���߰�װ����
echo ====================================================
echo.
echo ���ڰ�װ��...
echo.
taskkill /f /im NetworkTestControl.exe

if "%PROCESSOR_ARCHITECTURE%"=="x86" goto x86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto x64

:x86
echo.

if exist "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" del /q "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"

if not exist "%programfiles%\CJH\NetworkTestControl" md "%programfiles%\CJH\NetworkTestControl"
copy "%~dp0NetworkTestControl.exe" "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"
echo.
choice /C YN /T 5 /D Y /M "��(Y)��(N)Ҫ����Զ������5����Զ�ѡ��Y��"
if errorlevel 1 set aa=1
if errorlevel 2 set aa=2
if "%aa%" == "1" echo.
if "%aa%" == "1" echo �����ʱ��ͣ���ڴ˲����������Ƿ�ɱ��������ء�
if "%aa%" == "1" echo.
if "%aa%" == "1" Reg add HKLM\Software\Microsoft\Windows\CurrentVersion\run /v NetworkTestControl /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" /f
if "%aa%" == "1" schtasks.exe /Delete /TN NetworkTestControl /F
if "%aa%" == "1" schtasks.exe /create /tn NetworkTestControl /xml "%~dp0NetworkTestControl.xml"
echo.

echo.
choice /C YN /T 5 /D Y /M "��(Y)��(N)Ҫ������ݷ�ʽ����ʼ�˵���5����Զ�ѡ��Y��"
if errorlevel 1 set ad=1
if errorlevel 2 set ad=2
if "%ad%" == "1" if not exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����" md "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����"
if "%ad%" == "1" if exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С����.lnk" del /q "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С����.lnk"
if "%ad%" == "1" call mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(""%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С����.lnk""):b.TargetPath=""%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"":b.WorkingDirectory=""%programfiles%\CJH\NetworkTestControl"":b.Save:close")

copy /y "%~dp02-ж��.bat" "%programfiles%\CJH\NetworkTestControl\Uninstall.bat"

echo.
choice /C YN /T 5 /D Y /M "��(Y)��(N)���ж�س����б�5����Զ�ѡ��Y��"
if errorlevel 1 set ae=1
if errorlevel 2 set ae=2
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayIcon /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayName /t REG_SZ /d "�������С���ߣ�NetworkTestControl��" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v Publisher /t REG_SZ /d "CJH" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v UninstallString /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\Uninstall.bat" /f

start /d "%programfiles%\CJH\NetworkTestControl" "" "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"

echo.
cls

echo.
echo ====================================================
echo               �������С���߰�װ����
echo ====================================================
echo.
echo ��װ��ɣ�������˳�... & pause > nul
goto enda

:x64
echo.
Reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\run /v NetworkTestControl /f

if exist "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" del /q "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"
if exist "%programfiles%\CJH\NetworkTestControl\x86\NetworkTestControl.exe" del /q "%programfiles%\CJH\NetworkTestControl\x86\NetworkTestControl.exe"

if not exist "%programfiles%\CJH\NetworkTestControl" md "%programfiles%\CJH\NetworkTestControl"
if not exist "%programfiles%\CJH\NetworkTestControl\x86" md "%programfiles%\CJH\NetworkTestControl\x86"
copy "%~dp0NetworkTestControl64.exe" "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"
copy "%~dp0NetworkTestControl.exe" "%programfiles%\CJH\NetworkTestControl\x86\NetworkTestControl.exe"
echo.
choice /C YN /T 5 /D Y /M "��(Y)��(N)Ҫ����Զ������5����Զ�ѡ��Y��"
if errorlevel 1 set aa=1
if errorlevel 2 set aa=2
if "%aa%" == "1" echo.
if "%aa%" == "1" echo �����ʱ��ͣ���ڴ˲����������Ƿ�ɱ��������ء�
if "%aa%" == "1" echo.
if "%aa%" == "1" Reg add HKLM\Software\Microsoft\Windows\CurrentVersion\run /v NetworkTestControl /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" /f
if "%aa%" == "1" schtasks.exe /Delete /TN NetworkTestControl /F
if "%aa%" == "1" schtasks.exe /create /tn NetworkTestControl /xml "%~dp0NetworkTestControl.xml"
echo.

echo.
choice /C YN /T 5 /D Y /M "��(Y)��(N)Ҫ������ݷ�ʽ����ʼ�˵���5����Զ�ѡ��Y��"
if errorlevel 1 set ad=1
if errorlevel 2 set ad=2
if "%ad%" == "1" if not exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����" md "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����"
if "%ad%" == "1" if exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С����.lnk" del /q "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С����.lnk"
if "%ad%" == "1" if exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С���ߣ�32λ��.lnk" del /q "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С���ߣ�32λ��.lnk"
if "%ad%" == "1" call mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(""%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С����.lnk""):b.TargetPath=""%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"":b.WorkingDirectory=""%programfiles%\CJH\NetworkTestControl"":b.Save:close")
if "%ad%" == "1" call mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(""%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����\�������С���ߣ�32λ��.lnk""):b.TargetPath=""%programfiles%\CJH\NetworkTestControl\x86\NetworkTestControl.exe"":b.WorkingDirectory=""%programfiles%\CJH\NetworkTestControl\x86"":b.Save:close")

copy /y "%~dp02-ж��.bat" "%programfiles%\CJH\NetworkTestControl\Uninstall.bat"

echo.
choice /C YN /T 5 /D Y /M "��(Y)��(N)���ж�س����б�5����Զ�ѡ��Y��"
if errorlevel 1 set ae=1
if errorlevel 2 set ae=2
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayIcon /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayName /t REG_SZ /d "�������С���ߣ�NetworkTestControl��" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v Publisher /t REG_SZ /d "CJH" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v UninstallString /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\Uninstall.bat" /f

start /d "%programfiles%\CJH\NetworkTestControl" "" "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"

echo.
cls

echo.
echo ====================================================
echo                �������С���߰�װ����
echo ====================================================
echo.
echo ��װ��ɣ�������˳�... & pause > nul
goto enda

:enda