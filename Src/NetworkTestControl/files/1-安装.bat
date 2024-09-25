::/*****************************************************\
::
::     NetworkTestControl - 1-安装.bat
::
::     版权所有(C) 2024 CJH。
::
::     安装批处理
::
::\*****************************************************/
@echo off
::*****************************************************
::备注：你可以通过设置以下注册表值来自定义配置
::如果不存在该值或格式无效将使用默认设置。
::1.检测网络是否超时的间隔时间（毫秒ms）（建议大于1000ms，否则连接失败提示看不清楚而且间隔越短越耗系统内存）：
::项HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings 值TestTimer 类型REG_DWORD （默认值为1000）
::2.检测网络超时的地址（请确保地址有效，否则检测结果可能不正确！）：
::项HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings 值TestHostName 类型REG_SZ （默认值为www.baidu.com）
::3.检测网络连接是否超时的超时时间（毫秒ms）（请确保超时时间不要设置太短，一般为2000以下都正常）：
::项HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings 值Timeout 类型REG_DWORD （默认值为2000）
::4.检测网络连接状态的间隔时间（毫秒ms）（建议大于1000ms，否则连接失败提示看不清楚而且间隔越短越耗系统内存）：
::项HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings 值NetworkTimer 类型REG_DWORD （默认值为1000）
::5.使用Tcp模式检测延时（不建议，目前最新版本已经改为调用VB自带的Ping方法，使用该模式可能因创建连接过多而造成网络拥堵）（0=关闭，1=开启）：
::项HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings 值UseTcpTest 类型REG_DWORD （默认值为0）
::6.关闭网络检测（不建议，关闭之后只能判断系统网络连接状态，不能判断网络是否延时）（0=开启网络检测，1=关闭网络检测）：
::项HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings 值DisableNetworkTest 类型REG_DWORD （默认值为0）
::*****************************************************
cls
title 网络测试小工具安装程序
if "%1" == "/noadm" goto main
if "%1" == "/?" goto hlp
fltmc 1>nul 2>nul&& goto main
echo 正在获取管理员权限...
echo.
echo 可以使用 %0 /noadm 跳过Bat提权，但请手动以管理员身份运行
echo 如果当前窗口无限循环出现，或者未成功获取管理员权限，请注销当前用户或重启电脑，
echo 然后以管理员用户账号运行或手动以管理员身份运行。
if "%1" == "/mshtaadm" goto mshtaAdmin
if "%1" == "/psadm" goto powershellAdmin
ver | findstr "10\.[0-9]\.[0-9]*" >nul && goto powershellAdmin
:mshtaAdmin
rem 原理是利用mshta运行vbscript脚本给bat文件提权
rem 这里使用了前后带引号的%~dpnx0来表示当前脚本，比原版的短文件名%~s0更可靠
rem 这里使用了两次Net session，第二次是检测是否提权成功，如果提权失败则跳转到failed标签
rem 这有效避免了提权失败之后bat文件继续执行的问题
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
rem 原理是利用powershell给bat文件提权
rem 这里使用了两次Net session，第二次是检测是否提权成功，如果提权失败则跳转到failed标签
rem 这有效避免了提权失败之后bat文件继续执行的问题
Net session >nul 2>&1 || powershell start-process \"%0\" -argumentlist \"%1 %2\" -verb runas && exit
Net session >nul 2>&1 || goto failed
goto main

:failed
cls
echo.
echo 当前未以管理员身份运行。请手动以管理员身份运行本程序。
echo.
echo 任意键关闭... & pause > NUL
goto enda

:hlp
title 网络测试小工具安装程序
cls
echo.
echo ====================================================
echo               网络测试小工具安装程序
echo ====================================================
echo.
echo 你可以使用以下参数：
echo 1-安装.bat [/noadm ^| /mshtaadm ^| /psadm]
echo.
echo /noadm 当检测到无管理员权限跳过自动提权。
echo /mshtaadm 强制使用mshta.exe自动提权。
echo /psadm 强制使用Powershell.exe自动提权。
echo.
goto enda

:main
cd /d "%~dp0"
title 网络测试小工具安装程序
cls
echo.
echo ====================================================
echo               网络测试小工具安装程序
echo ====================================================
echo.
echo 版权所有(C) 2024 CJH。
echo.
echo 安装前建议关闭杀毒软件以及在UAC设置中设置UAC等级为最低，否则在安装主程序或如果选择写入自动启动项会被拦截导致安装失败。
echo.
echo 任意键开始安装... & pause >nul

cls
echo.
echo ====================================================
echo               网络测试小工具安装程序
echo ====================================================
echo.
echo 正在安装中...
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
choice /C YN /T 5 /D Y /M "是(Y)否(N)要添加自动启动项（5秒后自动选择Y）"
if errorlevel 1 set aa=1
if errorlevel 2 set aa=2
if "%aa%" == "1" echo.
if "%aa%" == "1" echo 如果长时间停留在此操作，请检测是否被杀毒软件拦截。
if "%aa%" == "1" echo.
if "%aa%" == "1" Reg add HKLM\Software\Microsoft\Windows\CurrentVersion\run /v NetworkTestControl /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" /f
if "%aa%" == "1" schtasks.exe /Delete /TN NetworkTestControl /F
if "%aa%" == "1" schtasks.exe /create /tn NetworkTestControl /xml "%~dp0NetworkTestControl.xml"
echo.

echo.
choice /C YN /T 5 /D Y /M "是(Y)否(N)要创建快捷方式到开始菜单（5秒后自动选择Y）"
if errorlevel 1 set ad=1
if errorlevel 2 set ad=2
if "%ad%" == "1" if not exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具" md "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具"
if "%ad%" == "1" if exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具.lnk" del /q "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具.lnk"
if "%ad%" == "1" call mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(""%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具.lnk""):b.TargetPath=""%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"":b.WorkingDirectory=""%programfiles%\CJH\NetworkTestControl"":b.Save:close")

copy /y "%~dp02-卸载.bat" "%programfiles%\CJH\NetworkTestControl\Uninstall.bat"

echo.
choice /C YN /T 5 /D Y /M "是(Y)否(N)添加卸载程序列表（5秒后自动选择Y）"
if errorlevel 1 set ae=1
if errorlevel 2 set ae=2
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayIcon /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayName /t REG_SZ /d "网络测试小工具（NetworkTestControl）" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v Publisher /t REG_SZ /d "CJH" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v UninstallString /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\Uninstall.bat" /f

start /d "%programfiles%\CJH\NetworkTestControl" "" "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"

echo.
cls

echo.
echo ====================================================
echo               网络测试小工具安装程序
echo ====================================================
echo.
echo 安装完成！任意键退出... & pause > nul
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
choice /C YN /T 5 /D Y /M "是(Y)否(N)要添加自动启动项（5秒后自动选择Y）"
if errorlevel 1 set aa=1
if errorlevel 2 set aa=2
if "%aa%" == "1" echo.
if "%aa%" == "1" echo 如果长时间停留在此操作，请检测是否被杀毒软件拦截。
if "%aa%" == "1" echo.
if "%aa%" == "1" Reg add HKLM\Software\Microsoft\Windows\CurrentVersion\run /v NetworkTestControl /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" /f
if "%aa%" == "1" schtasks.exe /Delete /TN NetworkTestControl /F
if "%aa%" == "1" schtasks.exe /create /tn NetworkTestControl /xml "%~dp0NetworkTestControl.xml"
echo.

echo.
choice /C YN /T 5 /D Y /M "是(Y)否(N)要创建快捷方式到开始菜单（5秒后自动选择Y）"
if errorlevel 1 set ad=1
if errorlevel 2 set ad=2
if "%ad%" == "1" if not exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具" md "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具"
if "%ad%" == "1" if exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具.lnk" del /q "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具.lnk"
if "%ad%" == "1" if exist "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具（32位）.lnk" del /q "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具（32位）.lnk"
if "%ad%" == "1" call mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(""%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具.lnk""):b.TargetPath=""%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"":b.WorkingDirectory=""%programfiles%\CJH\NetworkTestControl"":b.Save:close")
if "%ad%" == "1" call mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(""%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\网络测试小工具\网络测试小工具（32位）.lnk""):b.TargetPath=""%programfiles%\CJH\NetworkTestControl\x86\NetworkTestControl.exe"":b.WorkingDirectory=""%programfiles%\CJH\NetworkTestControl\x86"":b.Save:close")

copy /y "%~dp02-卸载.bat" "%programfiles%\CJH\NetworkTestControl\Uninstall.bat"

echo.
choice /C YN /T 5 /D Y /M "是(Y)否(N)添加卸载程序列表（5秒后自动选择Y）"
if errorlevel 1 set ae=1
if errorlevel 2 set ae=2
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayIcon /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v DisplayName /t REG_SZ /d "网络测试小工具（NetworkTestControl）" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v Publisher /t REG_SZ /d "CJH" /f
if "%ae%" == "1" Reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetworkTestControl /v UninstallString /t REG_SZ /d "%programfiles%\CJH\NetworkTestControl\Uninstall.bat" /f

start /d "%programfiles%\CJH\NetworkTestControl" "" "%programfiles%\CJH\NetworkTestControl\NetworkTestControl.exe"

echo.
cls

echo.
echo ====================================================
echo                网络测试小工具安装程序
echo ====================================================
echo.
echo 安装完成！任意键退出... & pause > nul
goto enda

:enda