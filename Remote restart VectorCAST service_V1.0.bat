@echo off
cls
echo.
echo.
color 4
echo #########################��ѡ��Ҫִ�еĲ���#########################
echo --1������Y�����س���ִ��VectorCAST License Service����������������--
echo -------------2������N�����س����˳���������ִ�д���-----------------
echo.
echo ��ѡ��Ҫִ�еĲ���:
set /p char=

if "%char%"=="Y" (
echo.
net use \\win-server\ipc$ "Password123" /user:"CXXX"

SC \\win-server  stop "VectorCAST License Service"

SC \\win-server  start "VectorCAST License Service"

rem net stop "VectorCAST License Service"
rem net start "VectorCAST License Service"
echo.
color 2
echo "VectorCAST License Service���������ɹ���"
pause
)

if "%char%"=="N" (
echo.
echo ������%char%�ַ����Զ��˳�����ִ�д��ڣ�
pause
)

