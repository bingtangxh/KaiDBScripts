@echo off
cls
setlocal ENABLEEXTENSIONS
if not "%cd%\"=="%~dp0" (
    echo ����:
    echo ��ǰ����Ŀ¼���Ǳ����������ļ���
    echo ��ʱ�����ļ���ع��ܿ��ܲ�����������.
    echo.
    pause
    cls
)
if not exist adb.exe (
    echo ����:
    echo û�м�⵽adb.exe
    echo �뽫����ļ��뱾�������һ��,��ѡ����.
    echo.
    pause
    cls
)
if not exist .\Palemoon\Bin\Palemoon.exe (
    echo ����:
    echo û�м�⵽����������Ŀ¼�µ�PalemoonĿ¼
    echo �����ܴ�����������WebIDE.
    echo.
    pause
    cls
)
:mainMenu
cls
echo ������δ�����κβ���,���������,��������������;!
echo.
pause
cls
echo ��ӭ����KaiOSӦ�ð�װ��ݽű�
echo ��ѡ������Ҫ�Ĺ���
echo ================================
echo [1] �鿴�����ӵ��豸
echo [2] ӳ���ֻ��������˿�
if exist .\Palemoon\Bin\Palemoon.exe echo [3] ����WebIDE
echo [4a] ���ֻ�����webapps.json
echo [4b] ���ֻ�����webapps.json
echo [5a] ���ֻ�����ָ�������
echo [5b] ���ֻ�����ָ�������
echo [0] �˳�������
echo [0a] �˳��������˳�����̨
echo.
set /p "ch=����������ѡ��,Ȼ��Enter:"
if "%ch%"=="1" (
    echo.
    adb devices
    echo.
    pause
    goto mainMenu
)
if "%ch%"=="2" goto forward
if "%ch%"=="3" (
    start .\Palemoon\Bin\Palemoon.exe -WebIDE -profile .\Palemoon\User\Palemoon\Profiles\Default
    goto mainMenu
)
if "%ch%"=="4a" (
    if exist webapps.json (
        cls
        echo webapps.json�Ѵ���,������,���ܻḲ�Ǵ��ļ�.
        echo ���Ƚ�ԭ���ļ��ƶ���������,Ȼ���������.
        echo.
        pause
        cls
    )
    echo.
    adb pull /data/local/webapps/webapps.json
    echo.
    pause
    goto mainMenu
)
if "%ch%"=="4b" (
    cls
    echo ��������Ҫ�Ƚ��ֻ���ʱRoot
    echo �����Ҫ�����ֻ��ϰ�װWallace Toolbox��ʹ����ʱRoot����.
    echo �����6300/8000,����Ҫ��ǰ����Խ��,�������������վ:
    echo https://opengiraffes.top
    echo ���û����Root,Ҳ�����ȼ���,adb��ʾʧ�ܺ�ɷ������˵�.
    echo.
    pause
    adb push webapps.json /data/local/webapps/webapps.json
    echo.
    pause
    goto mainMenu
)
if "%ch%"=="5a" goto pullWebapp
if "%ch%"=="5b" goto pushWebapp
if "%ch%"=="0" goto end
if "%ch%"=="0a" exit
echo.
echo ������������,����������.
echo.
pause
goto mainMenu

:forward
cls
echo �˴���������������Ƿ���Ч,��ȷ��������ȷ.
echo.
set port=
set /p "port=��������Ҫӳ��Ķ˿ں�,Ȼ��Enter.��������Ĭ��Ϊ6000:"
if "%port%"=="" set port=6000
cls
adb forward tcp:%port% localfilesystem:/data/local/debugger-socket
echo.
pause
goto mainMenu

:pullWebapp
cls
echo ��������Ҫ���Ƶİ���,Ȼ��Enter.�˴���������������Ƿ���Ч.
echo ����Ҫ���Ƽ���Ӧ��,������keyboard.gaiamobile.org
echo ���տɷ���.
echo.
set appName=
set /p appName=
if "%appName%"=="" goto mainMenu
echo.
echo ��ѡ������Դ,Ȼ��Enter.
echo ���ȡ�������Ǵ�ϵͳԭ��Ӧ���޸Ļ�����ȡ�û���װ��Ӧ��.
echo Ҫ����ϵͳԭ����Ӧ��,��ѡ��ѡ��1.
echo Ҫ��ȡ�û���װ��Ӧ��,��ѡ��ѡ��2.
echo �����������︴�Ƶ�����,�������������Ƶ��ֻ�ʱֻ�ܸ��Ƹ�/data/local.
echo ���������޹���ֵ�ɷ���.
echo.
echo [1]/system/b2g [2]/data/local
echo.
set /p source=
if "%source%"=="1" adb pull /system/b2g/webapps/%appName% && goto pullNote
if "%source%"=="2" adb pull /data/local/webapps/%appName% && goto pullNote
goto pullWebapp

:pullNote
if not exist %appName%\NUL (
    echo û���ҵ����Ƴ������ļ���
    echo ���������,�п��ܸ����Ѿ��ɹ�
    echo ���Ǹ��Ƴ������ļ����ܲ���һ���������ļ�����
    echo ������ɢ�ļ�(ͨ����application.zip��manifest.webapp)
    echo ��ֱ�ӷ����ڵ�ǰ�����ļ���(%cd%)
    echo ����,�������Զ�Ϊ������һ���ͳ����ͬ���Ŀ��ļ���
    echo ������ͨ���鿴�����ļ����´���������%date% %time%���ļ�
    echo �������ֶ��ƶ��������򴴽��Ķ����ļ���
    echo ���û���ҵ�,��۲��Ϸ�adb���,�����Ƿ�ʧ����.
    mkdir %appName%
)
echo.
pause
goto mainMenu

:pushWebapp
cls
if 1==1 (
    cls
    echo ��������Ҫ�Ƚ��ֻ���ʱRoot
    echo �����Ҫ�����ֻ��ϰ�װWallace Toolbox��ʹ����ʱRoot����.
    echo �����6300/8000,����Ҫ��ǰ����Խ��,�������������վ:
    echo https://opengiraffes.top
    echo ���û����Root,Ҳ�����ȼ���,adb��ʾʧ�ܺ�ɷ������˵�.
    echo.
    pause
)
cls
echo ��������Ҫ���Ƶİ���,Ȼ��Enter.
echo ����Ҫ���Ƽ���Ӧ��,������keyboard.gaiamobile.org
echo ���տɷ���.
echo.
set appName=
set /p appName=
if "%appName%"=="" goto mainMenu
if not exist %appName%\NUL (
    echo.
    echo ������������,����������.
    echo.
    pause
    goto pushWebapp
)
echo.
adb push %appName% /data/local/webapps
echo.
pause
goto mainMenu

:end
endlocal