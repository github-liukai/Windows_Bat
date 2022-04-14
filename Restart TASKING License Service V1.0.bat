@echo off

echo ########################TASKING License服务重启脚本###########################
echo #                                                                            #
echo #             注意：运行前该脚本前请确保已连接CamelTech网络                  #
echo #                                                                            #
echo ##############################################################################

setlocal enabledelayedexpansion

::#######################################################################################################
::从TASKING License服务端获取license.log
net use \\win-server\C$ "Password123" /user:"Camel"
copy \\win-server\flexlm\license.log
copy \\win-server\ComputerUserName\Computer_Device_User_Name.txt

echo 成功从服务端获取TASKING License Log，请见当前目录下license.log 文件！
echo.
::#######################################################################################################


::#######################################################################################################
::将本日的license Log输出到Today_log.txt中，仅输出最近(lmgrd) TIMESTAMP时间之后的Log，此Case后期修改策略;

rem echo 请输入今天日期格式:MM/DD/YY （时间小于10无需补0，如2022年1月6日请输入：1/6/2022）
rem set /p T_Date=

set y=%date:~0,4%
rem echo 当前系统年：%y%

rem set m=%date:~5,1%

if %date:~5,1% equ 0 (
set m=%date:~6,1%
) else ( set m=%date:~5,2% )
rem echo 当前系统月：%m%

if %date:~8,1% equ 0 (
set d=%date:~9,1%
) else ( set d=%date:~8,2% )
rem echo 当前系统日：%d%

set Symbol=/

set  T_Date=%m%%Symbol%%d%%Symbol%%y%
set "T_Date=%T_Date: =%"
echo 当前系统日期：%T_Date%


for /f "delims=: tokens=1" %%a in ('findstr /n "%T_Date%" "license.log"') do (
set Line=%%a
goto end
)
:end
set /a Line-=1
set skip=skip=%Line%
(for /f "%skip% delims=" %%a in (license.log) do (
    set /a num+=1
    echo,%%a
))>>Today_license_log.txt

::#######################################################################################################


::#######################################################################################################
::将今天的Today_license_log.txt中截取近%T_flag%分钟内log

::~~~~~~~~~~~~~~~获取log截取时间~~~~~~~~~~~~~~~~~~~~

set current_time=%time:~0,5% 
echo 当前系统时间：%current_time%



:: echo 请输入需要获取小时数：
set /a current_hour=%time:~0,2%
rem echo 当前系统小时：%current_hour%

set  flag_semicolon=:
rem echo 小时分钟分隔符：%flag_semicolon%

:: echo 请输入需要获取分钟数：
if %current_time:~3,1% equ 0 (
set /a current_minute=%current_time:~4,1%
) else ( set /a current_minute=%current_time:~3,2%)

rem set /a current_minute=%current_time:~-3%
rem if %current_minute:~0,1% equ 0 (
rem set /a current_minute=%current_time:~-2%
rem )
rem echo 当前系统分钟：%current_minute%

rem 设置需要查看的时间段
set /a T_flag=15


rem echo 查找log起始minute：%start_minute%
set /a start_minute=%current_minute%-%T_flag%
rem echo start_minute=%start_minute%
::~~~~~~~~~~~~~~~获取log截取时间~~~~~~~~~~~~~~~~~~~~

set /a flag_number=0
set /a zero=0

::~~~~~~~~~~~~~~~log截取:start_minute大于0: start~~~~~
echo.
echo 正查找%T_flag%分钟内TASKING使用信息，请稍后...
echo.

if %start_minute% geq 0 (

set /a temp_minute=!start_minute!

:again
if !temp_minute! lss 10 (
if !temp_minute! geq 0 (
set all_minutes=!zero!!temp_minute!
rem echo !all_minutes!
)) 

if !temp_minute! geq 10 (
set all_minutes=!temp_minute!
)

if !temp_minute! leq !current_minute! (
rem echo all_minutes:!all_minutes!
set all_time=!current_hour!!flag_semicolon!!all_minutes!!flag_semicolon!
echo 正查找!all_time!分TASKING使用信息，请稍后...

if "!all_time!"=="" (
echo 空) else (
type Today_license_log.txt | findstr "!all_time!" >> last_minutes.txt)

set /a flag_number+=1
set /a temp_minute=!start_minute!+!flag_number!
goto again
)
)
::~~~~~~~~~~~~~~~log截取:start_minute大于0: end~~~~~


::~~~~~~~~~~~~~~~log截取:start_minute小于0: start~~~~~

if %start_minute% lss 0 (
set /a negative_minutes=!T_flag!-!current_minute!
set /a negative_minutes=60-!negative_minutes!
rem echo negative_minutes=!negative_minutes!

set /a flag_negative_number=!negative_minutes!
set /a negative_current_hour=!current_hour!-1
set /a all_negative_minutes=!flag_negative_number!


:negativeagain
if !flag_negative_number! lss 60 (
rem echo all_minutes:!all_minutes_temp!
set all_negative_time=!negative_current_hour!!flag_semicolon!!all_negative_minutes!!flag_semicolon!
echo 正查找!all_negative_time!分TASKING使用信息，请稍后...

if "!all_negative_time!"=="" (
echo 空) else (
type Today_license_log.txt | findstr "!all_negative_time!" >> last_minutes.txt)

set /a flag_negative_number+=1
set /a all_negative_minutes=!flag_negative_number!

goto negativeagain 
)

:lssagain
set  /a temp_minute=!flag_number!
rem echo temp_minute=!temp_minute!

if !temp_minute! lss 10 (
if !temp_minute! geq 0 (
set all_minutes=!zero!!temp_minute!
)) 

if !temp_minute! geq 10 (
set /a all_minutes=!temp_minute! )

set /a flag_number+=1

if !temp_minute! leq !current_minute! (
rem echo all_minutes:!all_minutes_temp!
set all_time=!current_hour!!flag_semicolon!%all_minutes%!flag_semicolon!
echo 正查找!all_time!分TASKING使用信息，请稍后...

if "!all_time!"=="" (
echo 空) else (
type Today_license_log.txt | findstr "!all_time!" >> last_minutes.txt)
goto lssagain )
)
::~~~~~~~~~~~~~~~log截取:start_minute小于0: end~~~~~
::#######################################################################################################


::#######################################################################################################
::分割出Computer Device name（电脑设备名）并去重
echo.
echo 正在解析近%T_flag%分钟TASKING使用信息，请稍后...

for /f "delims=@ tokens=2,*" %%i in (last_minutes.txt) do (echo %%i>>computer_device_name.txt)

if not exist computer_device_name.txt (
  echo.
  echo 近%T_flag%分钟内没有用户使用TASKING！
  echo.
  
  del last_minutes.txt
  del Today_license_log.txt
  del Computer_Device_User_Name.txt
  
  goto restart
) 
rem 去重Computer Device name
set "file=computer_device_name.txt"

(for /f %%a in (%file%) do (
if not defined %%a (
set %%a=1
echo %%a
)
))>>finly_computer_device_name.txt
::#######################################################################################################


::#######################################################################################################
::根据Computer Device name（电脑设备名）匹配用户
rem echo 近%T_flag%分钟内连接使用TASKING License服务设备如下：
for /f  %%i in (finly_computer_device_name.txt) do (
rem echo %%i
type Computer_Device_User_Name.txt | findstr %%i >> user.txt
)

::#######################################################################################################

::#######################################################################################################
::打印电脑设备名
echo.
echo 近%T_flag%分钟内连接使用TASKING License服务用户如下：
for /f "delims=" %%i in (user.txt) do (
echo %%i
)
echo.
::#######################################################################################################


::#######################################################################################################
::删除过程文件
del computer_device_name.txt
del last_minutes.txt
del Today_license_log.txt
del finly_computer_device_name.txt
del user.txt
del Computer_Device_User_Name.txt
::#######################################################################################################


::#######################################################################################################
::TASKING License服务重启
rem color 0c
:restart
echo ########################TASKING License服务重启执行###########################
echo #                                                                            #
echo # （1）输入Y并按回车，执行TASKING License服务重启服务命令                    #
echo # （2）输入N并按回车，退出服务重启执行窗口                                   #
echo #                                                                            #
echo ##############################################################################
echo 注：重启服务命令前，请根据“近%T_flag%分钟内连接使用TASKING License服务用户”信息
echo     确认是否有工程师正在连接编译;

echo.
echo 请选择要执行的操作:
set /p char=

if "%char%"=="Y" (
echo.
net use \\win-server\ipc$ "Password123" /user:"Camel"

echo 正在重启TASING License服务，预计需要3秒，请稍后...
sc \\win-server  stop "FLEXlm License Manager for TASKING"
TIMEOUT /T 3
sc \\win-server  start "FLEXlm License Manager for TASKING"

echo.
color 2
echo "TASKING License Service服务重启成功！"
pause
)

if "%char%"=="N" (
echo.
echo 输入了%char%字符，自动退出服务执行窗口！
pause
)
::#######################################################################################################
