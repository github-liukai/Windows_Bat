@echo off

echo ########################TASKING License���������ű�###########################
echo #                                                                            #
echo #             ע�⣺����ǰ�ýű�ǰ��ȷ��������CamelTech����                  #
echo #                                                                            #
echo ##############################################################################

setlocal enabledelayedexpansion

::#######################################################################################################
::��TASKING License����˻�ȡlicense.log
net use \\win-server\C$ "Password123" /user:"Camel"
copy \\win-server\flexlm\license.log
copy \\win-server\ComputerUserName\Computer_Device_User_Name.txt

echo �ɹ��ӷ���˻�ȡTASKING License Log�������ǰĿ¼��license.log �ļ���
echo.
::#######################################################################################################


::#######################################################################################################
::�����յ�license Log�����Today_log.txt�У���������(lmgrd) TIMESTAMPʱ��֮���Log����Case�����޸Ĳ���;

rem echo ������������ڸ�ʽ:MM/DD/YY ��ʱ��С��10���貹0����2022��1��6�������룺1/6/2022��
rem set /p T_Date=

set y=%date:~0,4%
rem echo ��ǰϵͳ�꣺%y%

rem set m=%date:~5,1%

if %date:~5,1% equ 0 (
set m=%date:~6,1%
) else ( set m=%date:~5,2% )
rem echo ��ǰϵͳ�£�%m%

if %date:~8,1% equ 0 (
set d=%date:~9,1%
) else ( set d=%date:~8,2% )
rem echo ��ǰϵͳ�գ�%d%

set Symbol=/

set  T_Date=%m%%Symbol%%d%%Symbol%%y%
set "T_Date=%T_Date: =%"
echo ��ǰϵͳ���ڣ�%T_Date%


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
::�������Today_license_log.txt�н�ȡ��%T_flag%������log

::~~~~~~~~~~~~~~~��ȡlog��ȡʱ��~~~~~~~~~~~~~~~~~~~~

set current_time=%time:~0,5% 
echo ��ǰϵͳʱ�䣺%current_time%



:: echo ��������Ҫ��ȡСʱ����
set /a current_hour=%time:~0,2%
rem echo ��ǰϵͳСʱ��%current_hour%

set  flag_semicolon=:
rem echo Сʱ���ӷָ�����%flag_semicolon%

:: echo ��������Ҫ��ȡ��������
if %current_time:~3,1% equ 0 (
set /a current_minute=%current_time:~4,1%
) else ( set /a current_minute=%current_time:~3,2%)

rem set /a current_minute=%current_time:~-3%
rem if %current_minute:~0,1% equ 0 (
rem set /a current_minute=%current_time:~-2%
rem )
rem echo ��ǰϵͳ���ӣ�%current_minute%

rem ������Ҫ�鿴��ʱ���
set /a T_flag=15


rem echo ����log��ʼminute��%start_minute%
set /a start_minute=%current_minute%-%T_flag%
rem echo start_minute=%start_minute%
::~~~~~~~~~~~~~~~��ȡlog��ȡʱ��~~~~~~~~~~~~~~~~~~~~

set /a flag_number=0
set /a zero=0

::~~~~~~~~~~~~~~~log��ȡ:start_minute����0: start~~~~~
echo.
echo ������%T_flag%������TASKINGʹ����Ϣ�����Ժ�...
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
echo ������!all_time!��TASKINGʹ����Ϣ�����Ժ�...

if "!all_time!"=="" (
echo ��) else (
type Today_license_log.txt | findstr "!all_time!" >> last_minutes.txt)

set /a flag_number+=1
set /a temp_minute=!start_minute!+!flag_number!
goto again
)
)
::~~~~~~~~~~~~~~~log��ȡ:start_minute����0: end~~~~~


::~~~~~~~~~~~~~~~log��ȡ:start_minuteС��0: start~~~~~

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
echo ������!all_negative_time!��TASKINGʹ����Ϣ�����Ժ�...

if "!all_negative_time!"=="" (
echo ��) else (
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
echo ������!all_time!��TASKINGʹ����Ϣ�����Ժ�...

if "!all_time!"=="" (
echo ��) else (
type Today_license_log.txt | findstr "!all_time!" >> last_minutes.txt)
goto lssagain )
)
::~~~~~~~~~~~~~~~log��ȡ:start_minuteС��0: end~~~~~
::#######################################################################################################


::#######################################################################################################
::�ָ��Computer Device name�������豸������ȥ��
echo.
echo ���ڽ�����%T_flag%����TASKINGʹ����Ϣ�����Ժ�...

for /f "delims=@ tokens=2,*" %%i in (last_minutes.txt) do (echo %%i>>computer_device_name.txt)

if not exist computer_device_name.txt (
  echo.
  echo ��%T_flag%������û���û�ʹ��TASKING��
  echo.
  
  del last_minutes.txt
  del Today_license_log.txt
  del Computer_Device_User_Name.txt
  
  goto restart
) 
rem ȥ��Computer Device name
set "file=computer_device_name.txt"

(for /f %%a in (%file%) do (
if not defined %%a (
set %%a=1
echo %%a
)
))>>finly_computer_device_name.txt
::#######################################################################################################


::#######################################################################################################
::����Computer Device name�������豸����ƥ���û�
rem echo ��%T_flag%����������ʹ��TASKING License�����豸���£�
for /f  %%i in (finly_computer_device_name.txt) do (
rem echo %%i
type Computer_Device_User_Name.txt | findstr %%i >> user.txt
)

::#######################################################################################################

::#######################################################################################################
::��ӡ�����豸��
echo.
echo ��%T_flag%����������ʹ��TASKING License�����û����£�
for /f "delims=" %%i in (user.txt) do (
echo %%i
)
echo.
::#######################################################################################################


::#######################################################################################################
::ɾ�������ļ�
del computer_device_name.txt
del last_minutes.txt
del Today_license_log.txt
del finly_computer_device_name.txt
del user.txt
del Computer_Device_User_Name.txt
::#######################################################################################################


::#######################################################################################################
::TASKING License��������
rem color 0c
:restart
echo ########################TASKING License��������ִ��###########################
echo #                                                                            #
echo # ��1������Y�����س���ִ��TASKING License����������������                    #
echo # ��2������N�����س����˳���������ִ�д���                                   #
echo #                                                                            #
echo ##############################################################################
echo ע��������������ǰ������ݡ���%T_flag%����������ʹ��TASKING License�����û�����Ϣ
echo     ȷ���Ƿ��й���ʦ�������ӱ���;

echo.
echo ��ѡ��Ҫִ�еĲ���:
set /p char=

if "%char%"=="Y" (
echo.
net use \\win-server\ipc$ "Password123" /user:"Camel"

echo ��������TASING License����Ԥ����Ҫ3�룬���Ժ�...
sc \\win-server  stop "FLEXlm License Manager for TASKING"
TIMEOUT /T 3
sc \\win-server  start "FLEXlm License Manager for TASKING"

echo.
color 2
echo "TASKING License Service���������ɹ���"
pause
)

if "%char%"=="N" (
echo.
echo ������%char%�ַ����Զ��˳�����ִ�д��ڣ�
pause
)
::#######################################################################################################
