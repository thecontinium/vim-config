
augroup MyAutoCmd " {{{

	" save automatically when text is changed
	" it will save the current file whenever text is changed in normal mode
	" or you leave the insert mode.
	autocmd FileType markdown
		\ let b:sleuth_automatic = 0
	  \ | setlocal nospell path=. suffixesadd=.mmd
		\ | nnoremap <silent><buffer><LocalLeader>f :<C-u>Denite file/rec grep:::!<CR>
		\ | setlocal updatetime=200
		\ | au CursorHold <buffer> silent! update

	autocmd FileType clojure
		\ let b:sleuth_automatic = 0

	autocmd FileType yaml
		\ let b:sleuth_automatic = 0

augroup END " }}}


" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
