
" What to save in sessions:

let g:session_directory = expand('$HOME/Resilio Sync/app/vim/session')
set sessionoptions+=winpos
set sessionoptions+=buffers
" nmap <silent> <Leader>su :<C-u>let v:this_session='' && execute 'redrawtabline'<CR>
nmap <silent> <Leader>su :<C-u>call g:SessionUnload()<CR>
function! g:SessionUnload() abort
	let v:this_session=''
	silent execute 'redrawtabline'
endfunction

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

augroup my_user_plugin_denite " }}}
	autocmd!

	autocmd FileType denite
		\ nnoremap <silent><buffer><expr> sa denite#do_map('do_action', 'save')

augroup END " }}}

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
		\ | nnoremap <silent><buffer><LocalLeader>f :<C-u>DeniteBufferDir -sorters=sorter/lastmod file/rec grep:::!<CR>


	" only run vimwikireturn if the popup menu is not showing, otherwise close it
	autocmd filetype vimwiki
		\ inoremap <silent><buffer><expr><CR> pumvisible() ? deoplete#close_popup() : "<ESC>:VimwikiReturn 1 5<CR>"
		\ | setlocal sw=4
		\ | setlocal sts=4
		\ | setlocal et

autocmd FileType clojure
		\ let b:sleuth_automatic = 0
		\ | nnoremap <silent><buffer><LocalLeader>cn :<C-u>vsplit term://lein repl<CR>

	autocmd FileType yaml
		\ let b:sleuth_automatic = 0

augroup END " }}}

autocmd MyAutoCmd FileType defx do WinEnter | call s:defx_my_settings()
function! s:defx_my_settings() abort
	nnoremap <silent><buffer><expr><nowait> ^  defx#do_action('cd', defx#get_candidate().action__path)
	nnoremap <silent><buffer><expr>					=	 defx#do_action('call', 'DefxCD')
endfunction

" Set the vim directory to the selected
function! g:DefxCD(context) abort
	let l:target = a:context['targets'][0]
	let l:selected = fnamemodify(l:target, ':p:h')
	silent execute 'close'
	silent execute 'cd '.l:selected
	echo 'cd set to '.l:selected
endfunction

if dein#tap('neosnippet.vim')
	smap <expr><C-o> neosnippet#expandable_or_jumpable()
		\ ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
endif

" Neomake clojure additions
let g:neomake_joker_maker = {
		\ 'exe': 'joker',
		\ 'args': ['--lint'],
		\ 'errorformat': '%f:%l:%c: %*[^ ] %t%*[^:]: %m',
		\ }

let g:neomake_cljkondo_maker = {
		\ 'exe': 'clj-kondo',
		\ 'args': ['--lint'],
		\ 'errorformat': '%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m',
		\ 'remove_invalid_entries': 1,
		\ }

let g:neomake_clojure_enabled_makers = ['joker', 'cljkondo']

let g:sexp_mappings = {
		\ 'sexp_round_head_wrap_list':      ',i',
		\ 'sexp_round_tail_wrap_list':      ',I',
		\ 'sexp_square_head_wrap_list':     '',
		\ 'sexp_square_tail_wrap_list':     '',
		\ 'sexp_curly_head_wrap_list':      '',
		\ 'sexp_curly_tail_wrap_list':      '',
		\ 'sexp_round_head_wrap_element':   ',w',
		\ 'sexp_round_tail_wrap_element':   ',W',
		\ 'sexp_square_head_wrap_element':  '',
		\ 'sexp_square_tail_wrap_element':  '',
		\ 'sexp_curly_head_wrap_element':   '',
		\ 'sexp_curly_tail_wrap_element':   '',
		\ 'sexp_insert_at_list_head':       ',h',
		\ 'sexp_insert_at_list_tail':       ',l',
		\ 'sexp_splice_list':               ',@',
		\ 'sexp_convolute':                 ',?',
		\ 'sexp_raise_list':                ',o',
		\ 'sexp_raise_element':             ',O',
		\ }

" autocmd filetype vimwiki
" \ inoremap <silent><buffer><expr><CR> pumvisible() ? deoplete#close_popup() : "<ESC>:call <SID>do_wiki_cr()<CR>"
" function! s:do_wiki_cr()
"		:call vimwiki#vars#set_wikilocal('syntax','default',vimwiki#vars#get_bufferlocal('wiki_nr'))
"		:VimwikiReturn 1 5
"		:call vimwiki#vars#set_wikilocal('syntax','markdown',vimwiki#vars#get_bufferlocal('wiki_nr'))
" endfunction
" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
