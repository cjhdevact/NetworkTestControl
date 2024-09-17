@echo off
echo 任意键打包 网络测试小工具（NetworkTestControl）...
pause > nul
if exist %~dp0NetworkTestControl-Bin rd /s /q %~dp0NetworkTestControl-Bin
md %~dp0NetworkTestControl-Bin
copy %~dp0NetworkTestControl\bin\Release\NetworkTestControl.exe %~dp0NetworkTestControl-Bin\NetworkTestControl.exe
copy %~dp0NetworkTestControl\bin\x64\Release\NetworkTestControl.exe %~dp0NetworkTestControl-Bin\NetworkTestControl64.exe

copy %~dp0NetworkTestControl\files\1-安装.bat %~dp0NetworkTestControl-Bin\1-安装.bat
copy %~dp0NetworkTestControl\files\2-卸载.bat %~dp0NetworkTestControl-Bin\2-卸载.bat

echo.
echo 完成！
echo 任意键退出...
pause > nul