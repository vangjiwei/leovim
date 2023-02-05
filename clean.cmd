@if not exist "%HOME%" @set HOME=%USERPROFILE%
call del "%HOME%\.leovim.d\swap\*.*"   /a /f /q
call del "%HOME%\.leovim.d\shada.*"    /a /f /q
call del "%HOME%\.leovim.d\backup\*.*" /a /f /q
