@if not exist "%HOME%" @set HOME=%USERPROFILE%
call rmdir /Q /S "%HOME%\.leovim.d\cmp.nvim"
call rmdir /Q /S "%HOME%\.leovim.d\coc.*"
call rmdir /Q /S "%HOME%\.leovim.d\mcm.*"
call rmdir /Q /S "%HOME%\.leovim.d\apc.*"
call rmdir /Q /S "%HOME%\.leovim.d\non.*"
call rmdir /Q /S "%HOME%\.leovim.d\plug"
