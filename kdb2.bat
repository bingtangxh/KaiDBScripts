@echo off
cls
setlocal ENABLEEXTENSIONS
if not "%cd%\"=="%~dp0" (
    echo 警告:
    echo 当前工作目录不是本程序所在文件夹
    echo 届时传输文件相关功能可能不能正常工作.
    echo.
    pause
    cls
)
if not exist adb.exe (
    echo 警告:
    echo 没有检测到adb.exe
    echo 请将相关文件与本程序放在一起,再选择功能.
    echo.
    pause
    cls
)
if not exist .\Palemoon\Bin\Palemoon.exe (
    echo 警告:
    echo 没有检测到本程序所在目录下的Palemoon目录
    echo 将不能从这里快捷启动WebIDE.
    echo.
    pause
    cls
)
:mainMenu
cls
echo 本程序未经过任何测试,如产生问题,请勿用于生产用途!
echo.
pause
cls
echo 欢迎进入KaiOS应用安装快捷脚本
echo 请选择您需要的功能
echo ================================
echo [1] 查看已连接的设备
echo [2] 映射手机到本机端口
if exist .\Palemoon\Bin\Palemoon.exe echo [3] 启动WebIDE
echo [4a] 从手机复制webapps.json
echo [4b] 向手机复制webapps.json
echo [5a] 从手机复制指定程序包
echo [5b] 向手机复制指定程序包
echo [0] 退出本程序
echo [0a] 退出本程序并退出控制台
echo.
set /p "ch=请输入您的选择,然后按Enter:"
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
        echo webapps.json已存在,若继续,可能会覆盖此文件.
        echo 请先将原有文件移动或重命名,然后继续操作.
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
    echo 本操作需要先将手机临时Root
    echo 因此需要先在手机上安装Wallace Toolbox并使用临时Root功能.
    echo 如果是6300/8000,还需要提前进行越狱,详情请见以下网站:
    echo https://opengiraffes.top
    echo 如果没有先Root,也可以先继续,adb提示失败后可返回主菜单.
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
echo 您的输入有误,请重新输入.
echo.
pause
goto mainMenu

:forward
cls
echo 此处不检测您的输入是否有效,请确保输入正确.
echo.
set port=
set /p "port=请输入需要映射的端口号,然后按Enter.如留空则默认为6000:"
if "%port%"=="" set port=6000
cls
adb forward tcp:%port% localfilesystem:/data/local/debugger-socket
echo.
pause
goto mainMenu

:pullWebapp
cls
echo 请输入您要复制的包名,然后按Enter.此处不检测您的输入是否有效.
echo 例如要复制键盘应用,就输入keyboard.gaiamobile.org
echo 留空可返回.
echo.
set appName=
set /p appName=
if "%appName%"=="" goto mainMenu
echo.
echo 请选择复制来源,然后按Enter.
echo 这个取决于您是从系统原生应用修改还是提取用户安装的应用.
echo 要复制系统原生的应用,请选择选项1.
echo 要提取用户安装的应用,请选择选项2.
echo 无论您从哪里复制到电脑,当你改完软件后复制到手机时只能复制给/data/local.
echo 输入其他无关数值可返回.
echo.
echo [1]/system/b2g [2]/data/local
echo.
set /p source=
if "%source%"=="1" adb pull /system/b2g/webapps/%appName% && goto pullNote
if "%source%"=="2" adb pull /data/local/webapps/%appName% && goto pullNote
goto pullWebapp

:pullNote
if not exist %appName%\NUL (
    echo 没有找到复制出来的文件夹
    echo 此种情况下,有可能复制已经成功
    echo 但是复制出来的文件可能不在一个单独的文件夹里
    echo 而是零散文件(通常是application.zip和manifest.webapp)
    echo 被直接放置于当前工作文件夹(%cd%)
    echo 现在,本程序将自动为您创建一个和程序包同名的空文件夹
    echo 您可以通过查看工作文件夹下创建日期是%date% %time%的文件
    echo 将它们手动移动至本程序创建的独立文件夹
    echo 如果没有找到,请观察上方adb输出,看看是否失败了.
    mkdir %appName%
)
echo.
pause
goto mainMenu

:pushWebapp
cls
if 1==1 (
    cls
    echo 本操作需要先将手机临时Root
    echo 因此需要先在手机上安装Wallace Toolbox并使用临时Root功能.
    echo 如果是6300/8000,还需要提前进行越狱,详情请见以下网站:
    echo https://opengiraffes.top
    echo 如果没有先Root,也可以先继续,adb提示失败后可返回主菜单.
    echo.
    pause
)
cls
echo 请输入您要复制的包名,然后按Enter.
echo 例如要复制键盘应用,就输入keyboard.gaiamobile.org
echo 留空可返回.
echo.
set appName=
set /p appName=
if "%appName%"=="" goto mainMenu
if not exist %appName%\NUL (
    echo.
    echo 您的输入有误,请重新输入.
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