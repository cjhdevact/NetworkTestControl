::/*****************************************************\
::
::     NetworkTestControl - 2-ж��.bat
::
::     ��Ȩ����(C) 2024 CJH��
::
::     ж��������
::
::\*****************************************************/
@echo off
cls
title �������С����ж�س���
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
title �������С����ж�س���
cls
echo.
echo ====================================================
echo               �������С����ж�س���
echo ====================================================
echo.
echo �����ʹ�����²�����
echo 2-ж��.bat [/noadm ^| /mshtaadm ^| /psadm]
echo.
echo /noadm ����⵽�޹���ԱȨ�������Զ���Ȩ��
echo /mshtaadm ǿ��ʹ��mshta.exe�Զ���Ȩ��
echo /psadm ǿ��ʹ��Powershell.exe�Զ���Ȩ��
echo.
goto enda

:main
cd /d "%~dp0"
title �������С����ж�س���
cls
echo.
echo ====================================================
echo               �������С����ж�س���
echo ====================================================
echo.
echo ж��ǰ����ر�ɱ������Լ���UAC����������UAC�ȼ�Ϊ��ͣ�������ж���������Լ��Զ�������ᱻ���ص���ж��ʧ�ܡ�
echo.
echo �������ʼж��... & pause >nul

cls
echo.
echo ====================================================
echo               �������С����ж�س���
echo ====================================================
echo.
echo ����ж����...
echo.
taskkill /f /im NetworkTestControl.exe

if "%PROCESSOR_ARCHITECTURE%"=="x86" goto x86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto x64

:x86
echo.
echo �����ʱ��ͣ���ڴ˲����������Ƿ�ɱ��������ء�
echo.
Reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\run /v NetworkTestControl /f
rd /s /q "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����"
schtasks.exe /Delete /TN NetworkTestControl /F
if "%csu%" == "1" Reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayIcon /f
if "%csu%" == "1" Reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayName /f
if "%csu%" == "1" Reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v Publisher /f
if "%csu%" == "1" Reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v UninstallString /f
rd /s /q "%programfiles%\CJH\NetworkTestControl"
echo.
cls

echo.
echo ====================================================
echo               �������С����ж�س���
echo ====================================================
echo.
echo ж����ɣ�������˳�... & pause > nul
goto enda

:x64
echo.
echo �����ʱ��ͣ���ڴ˲����������Ƿ�ɱ��������ء�
echo.
Reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\run /v NetworkTestControl /f
rd /s /q "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\�������С����"
schtasks.exe /Delete /TN NetworkTestControl /F
if "%csu%" == "1" Reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayIcon /f
if "%csu%" == "1" Reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayName /f
if "%csu%" == "1" Reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v Publisher /f
if "%csu%" == "1" Reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v UninstallString /f
rd /s /q "%programfiles%\CJH\NetworkTestControl"
echo.
cls

echo.
echo ====================================================
echo               �������С����ж�س���
echo ====================================================
echo.
echo ж����ɣ�������˳�... & pause > nul
goto enda

:enda