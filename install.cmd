@if not exist "%HOME%" @set HOME=%USERPROFILE%
@set PWD=%~dp0
@set APP_PATH=%PWD:~0,-1%

REM mkdir necesarry
call md "%HOME%\AppData\local\nvim"

REM mklink of config dir
IF "%APP_PATH%" == "%HOME%\.leovim.conf" (
    echo "leovim is already installed in %HOME%\.leovim.conf"
) ELSE (
    echo "leovim is going to be linked to %HOME%\.leovim.conf"
    call rmdir "%HOME%\.leovim.conf"
    call mklink /d "%HOME%\.leovim.conf" "%APP_PATH%"
)
echo

REM delete files
call del "%HOME%\.vimrc"
call del "%HOME%\.gvimrc"
call del "%HOME%\AppData\local\nvim\init.vim"
call del "%HOME%\AppData\local\nvim\ginit.vim"

REM create vimrc
echo if filereadable(expand("~/.vimrc.test")) > "%HOME%\.vimrc"
echo    source ~/.vimrc.test >> "%HOME%\.vimrc"
echo else >> "%HOME%\.vimrc"
echo    source ~/.leovim.conf/init.vim >> "%HOME%\.vimrc"
echo endif >> "%HOME%\.vimrc"
REM cp vimrc
call copy "%HOME%\.vimrc" "%HOME%\.gvimrc"
call copy "%HOME%\.vimrc" "%HOME%\AppData\local\nvim\init.vim"
call copy "%HOME%\.vimrc" "%HOME%\AppData\local\nvim\ginit.vim"

REM mklink
call del    "%HOME%\_leovim.clean.cmd"
call mklink "%HOME%\_leovim.clean.cmd" "%APP_PATH%\clean.cmd"
call del    "%HOME%\_ideavimrc"
call mklink "%HOME%\_ideavimrc"        "%APP_PATH%\jetbrains\idea.vim"

REM mkdir for install
IF NOT EXIST "%HOME%\.leovim.d" (
    call md "%HOME%\.leovim.d"
)

REM copy local
IF NOT EXIST "%HOME%\.vimrc.local" (
    call copy "%APP_PATH%\scripts\local.vim" "%HOME%\.vimrc.local"
)

REM setup vim tools for windows
IF NOT EXIST "%HOME%\.leovim.windows" (
    call git clone --depth=1 https://gitee.com/leoatchina/leovim-windows.git "%HOME%\.leovim.windows"
) ELSE (
    call cd "%HOME%\.leovim.windows"
    call git pull
)
