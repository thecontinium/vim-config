let b:sleuth_automatic = 0
setlocal path=.
setlocal suffixesadd=.mmd
nnoremap <silent><buffer><LocalLeader>f :<C-u>Denite -input=mmd file/rec grep:::!<CR>
" save automatically when text is changed
setlocal updatetime=200
au CursorHold <buffer> silent! update
