if Installed('vim-signature')
    nnoremap [1 :call signature#marker#Goto('prev', 1, v:count)<Cr>
    nnoremap ]1 :call signature#marker#Goto('next', 1, v:count)<Cr>
    nnoremap [2 :call signature#marker#Goto('prev', 2, v:count)<Cr>
    nnoremap ]2 :call signature#marker#Goto('next', 2, v:count)<Cr>
    nnoremap [3 :call signature#marker#Goto('prev', 3, v:count)<Cr>
    nnoremap ]3 :call signature#marker#Goto('next', 3, v:count)<Cr>
    nnoremap [4 :call signature#marker#Goto('prev', 4, v:count)<Cr>
    nnoremap ]4 :call signature#marker#Goto('next', 4, v:count)<Cr>
    nnoremap [5 :call signature#marker#Goto('prev', 5, v:count)<Cr>
    nnoremap ]5 :call signature#marker#Goto('next', 5, v:count)<Cr>
    nnoremap [6 :call signature#marker#Goto('prev', 6, v:count)<Cr>
    nnoremap ]6 :call signature#marker#Goto('next', 6, v:count)<Cr>
    nnoremap [7 :call signature#marker#Goto('prev', 7, v:count)<Cr>
    nnoremap ]7 :call signature#marker#Goto('next', 7, v:count)<Cr>
    nnoremap [8 :call signature#marker#Goto('prev', 8, v:count)<Cr>
    nnoremap ]8 :call signature#marker#Goto('next', 8, v:count)<Cr>
    nnoremap [9 :call signature#marker#Goto('prev', 9, v:count)<Cr>
    nnoremap ]9 :call signature#marker#Goto('next', 9, v:count)<Cr>
    let g:SignatureMap = {
          \ 'Leader'            : "m",
          \ 'ToggleMarkAtLine'  : "m<Cr>",
          \ 'PurgeMarksAtLine'  : "m.",
          \ 'PlaceNextMark'     : "m;",
          \ 'DeleteMark'        : "m,",
          \ 'PurgeMarks'        : "m-",
          \ 'PurgeMarkers'      : "m=",
          \ 'GotoNextLineAlpha' : "']",
          \ 'GotoPrevLineAlpha' : "'[",
          \ 'GotoNextSpotAlpha' : "`]",
          \ 'GotoPrevSpotAlpha' : "`[",
          \ 'GotoNextLineByPos' : "]'",
          \ 'GotoPrevLineByPos' : "['",
          \ 'GotoNextSpotByPos' : "]`",
          \ 'GotoPrevSpotByPos' : "[`",
          \ 'GotoNextMarker'    : "]-",
          \ 'GotoPrevMarker'    : "[-",
          \ 'GotoNextMarkerAny' : "]=",
          \ 'GotoPrevMarkerAny' : "[=",
          \ 'ListBufferMarks'   : "m/",
          \ 'ListBufferMarkers' : "m?"
          \ }
endif
if Installed('leaderf-marks')
    nnoremap <C-f>m :Leaderf marks<Cr>
elseif InstalledTelescope()
    nnoremap <C-f>m :Telescope marks<Cr>
elseif InstalledFzf()
    nnoremap <C-f>m :FzfMarks<CR>
endif
if Installed('indentLine')
    let g:indentLine_color_dark      = 1 " (default: 2)
    let g:indentLine_color_tty_light = 7 " (default: 4)
    let g:indentLine_enabled         = 0
    let g:indentLine_color_term      = 239
    let g:indentLine_bgcolor_term    = 202
    let g:indentLine_color_gui       = '#A4E57E'
    let g:indentLine_bgcolor_gui     = '#FF5F00'
    let g:indentLine_char_list       = ['|', '¦', '┆', '┊']
    nnoremap <leader>\ :IndentLinesToggle<Cr>
endif
