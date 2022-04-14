@echo off
cls
echo.
echo.
color 4
echo #########################请选择要执行的操作#########################
echo --1、输入Y并按回车，执行VectorCAST License Service服务重启服务命令--
echo -------------2、输入N并按回车，退出服务重启执行窗口-----------------
echo.
echo 请选择要执行的操作:
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
echo "VectorCAST License Service服务重启成功！"
pause
)

if "%char%"=="N" (
echo.
echo 输入了%char%字符，自动退出服务执行窗口！
pause
)

