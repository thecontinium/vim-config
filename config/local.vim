

" terminal mappings
" map jj to exit terminal-mode
:tnoremap jj <C-\><C-N>
" use `CTRL+{h,j,k,l}` to navigate windows from any mode: >
:tnoremap <C-h> <C-\><C-N><C-w>h
:tnoremap <C-j> <C-\><C-N><C-w>j
:tnoremap <C-k> <C-\><C-N><C-w>k
:tnoremap <C-l> <C-\><C-N><C-w>l
:inoremap <C-h> <C-\><C-N><C-w>h
:inoremap <C-j> <C-\><C-N><C-w>j
:inoremap <C-k> <C-\><C-N><C-w>k
:inoremap <C-l> <C-\><C-N><C-w>l
:nnoremap <C-h> <C-w>h
:nnoremap <C-j> <C-w>j
:nnoremap <C-k> <C-w>k
:nnoremap <C-l> <C-w>l

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
		\ | nnoremap <silent><buffer><LocalLeader>f :<C-u>Denite -path=~/Dropbox/notesy -sorters=sorter/lastmod file/rec grep:::!<CR>

	" only run vimwikireturn if the popup menu is not showing, otherwise close it
	autocmd filetype vimwiki
		\ inoremap <silent><buffer><expr><CR> pumvisible() ? deoplete#close_popup() : "<ESC>:VimwikiReturn 1 5<CR>"

autocmd FileType clojure
		\ let b:sleuth_automatic = 0

	autocmd FileType yaml
		\ let b:sleuth_automatic = 0

augroup END " }}}

" autocmd filetype vimwiki
" \ inoremap <silent><buffer><expr><CR> pumvisible() ? deoplete#close_popup() : "<ESC>:call <SID>do_wiki_cr()<CR>"
" function! s:do_wiki_cr()
"		:call vimwiki#vars#set_wikilocal('syntax','default',vimwiki#vars#get_bufferlocal('wiki_nr'))
"		:VimwikiReturn 1 5
"		:call vimwiki#vars#set_wikilocal('syntax','markdown',vimwiki#vars#get_bufferlocal('wiki_nr'))
" endfunction
" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
