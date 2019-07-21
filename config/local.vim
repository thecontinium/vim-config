augroup MyAutoCmd " {{{

	" save automatically when text is changed
	" it will save the current file whenever text is changed in normal mode
	" or you leave the insert mode.
	autocmd FileType markdown
	  \ setlocal nospell path=. suffixesadd=.mmd
		\ | setlocal updatetime=200
		\ | au CursorHold <buffer> silent! update

	autocmd FileType vimwiki,markdown
		\ let b:sleuth_automatic = 0
		\ | setlocal concealcursor=nc
		\ | nnoremap <silent><buffer><LocalLeader>f :<C-u>Denite -path=~/Dropbox/notesy file/rec grep:::!<CR>

	" only run vimwikireturn if the popup menu is not showing, otherwise close it
	autocmd filetype vimwiki
		\ inoremap <silent><buffer><expr><CR> pumvisible() ? deoplete#close_popup() : "<esc>:vimwikireturn 1 5<cr>"


autocmd FileType clojure
		\ let b:sleuth_automatic = 0

	autocmd FileType yaml
		\ let b:sleuth_automatic = 0

augroup END " }}}


" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
