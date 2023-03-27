nnoremap M m
if Installed('vim-signature')
    nnoremap <silent>[1 :call signature#marker#Goto('prev', 1, v:count)<Cr>
    nnoremap <silent>]1 :call signature#marker#Goto('next', 1, v:count)<Cr>
    nnoremap <silent>[2 :call signature#marker#Goto('prev', 2, v:count)<Cr>
    nnoremap <silent>]2 :call signature#marker#Goto('next', 2, v:count)<Cr>
    nnoremap <silent>[3 :call signature#marker#Goto('prev', 3, v:count)<Cr>
    nnoremap <silent>]3 :call signature#marker#Goto('next', 3, v:count)<Cr>
    nnoremap <silent>[4 :call signature#marker#Goto('prev', 4, v:count)<Cr>
    nnoremap <silent>]4 :call signature#marker#Goto('next', 4, v:count)<Cr>
    nnoremap <silent>[5 :call signature#marker#Goto('prev', 5, v:count)<Cr>
    nnoremap <silent>]5 :call signature#marker#Goto('next', 5, v:count)<Cr>
    nnoremap <silent>[6 :call signature#marker#Goto('prev', 6, v:count)<Cr>
    nnoremap <silent>]6 :call signature#marker#Goto('next', 6, v:count)<Cr>
    nnoremap <silent>[7 :call signature#marker#Goto('prev', 7, v:count)<Cr>
    nnoremap <silent>]7 :call signature#marker#Goto('next', 7, v:count)<Cr>
    nnoremap <silent>[8 :call signature#marker#Goto('prev', 8, v:count)<Cr>
    nnoremap <silent>]8 :call signature#marker#Goto('next', 8, v:count)<Cr>
    nnoremap <silent>[9 :call signature#marker#Goto('prev', 9, v:count)<Cr>
    nnoremap <silent>]9 :call signature#marker#Goto('next', 9, v:count)<Cr>
    let g:SignatureMap = {
                \ 'Leader'            : "m",
                \ 'DeleteMark'        : "dm",
                \ 'ToggleMarkAtLine'  : "m<Cr>",
                \ 'PlaceNextMark'     : "m;",
                \ 'PurgeMarksAtLine'  : "m,",
                \ 'PurgeMarks'        : "m.",
                \ 'PurgeMarkers'      : "m<Bs>",
                \ 'ListBufferMarks'   : "m/",
                \ 'ListBufferMarkers' : "m?",
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
                \ }
endif
if InstalledTelescope()
    nnoremap <C-f>m :Telescope marks<Cr>
elseif Installed('leaderf-marks')
    nnoremap <C-f>m :Leaderf marks<Cr>
elseif InstalledFZF()
    nnoremap <C-f>m :FZFMarks<CR>
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
