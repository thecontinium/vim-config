let b:sleuth_automatic = 0
setlocal path=.
setlocal suffixesadd=.mmd
nnoremap <silent><buffer><LocalLeader>f :<C-u>Denite -input=mmd file/rec grep:::!<CR>
" save automatically when text is changed
" it will save the current file whenever text is changed in normal mode 
" or you leave the insert mode. 
setlocal updatetime=200
au CursorHold <buffer> silent! update
