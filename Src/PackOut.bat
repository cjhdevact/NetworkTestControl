@echo off
echo �������� �������С���ߣ�NetworkTestControl��...
pause > nul
if exist %~dp0NetworkTestControl-Bin rd /s /q %~dp0NetworkTestControl-Bin
md %~dp0NetworkTestControl-Bin
copy %~dp0NetworkTestControl\bin\Release\NetworkTestControl.exe %~dp0NetworkTestControl-Bin\NetworkTestControl.exe
copy %~dp0NetworkTestControl\bin\x64\Release\NetworkTestControl.exe %~dp0NetworkTestControl-Bin\NetworkTestControl64.exe

copy %~dp0NetworkTestControl\files\1-��װ.bat %~dp0NetworkTestControl-Bin\1-��װ.bat
copy %~dp0NetworkTestControl\files\2-ж��.bat %~dp0NetworkTestControl-Bin\2-ж��.bat

echo.
echo ��ɣ�
echo ������˳�...
pause > nul