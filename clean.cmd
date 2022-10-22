@if not exist "%HOME%" @set HOME=%USERPROFILE%
call del "%HOME%\.leovim.d\swap\*.*"     /a /f /q
call del "%HOME%\.leovim.d\backup\*.*"   /a /f /q
call del "%HOME%\.leovim.d\shada.main.*" /a /f /q
