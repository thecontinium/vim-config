
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

augroup user_plugin_filetype " {{{
	" set to default so that we get the warningd and options
	autocmd swapexists * nested let v:swapchoice = ''
augroup END " }}}

augroup my_user_plugin_denite " {{{
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

autocmd MyAutoCmd FileType defx call <SID>defx_my_settings()
function! s:defx_my_settings() abort
	nnoremap <silent><buffer><expr><nowait> ^  defx#do_action('cd', defx#get_candidate().action__path)
	nnoremap <silent><buffer><expr>					=	 defx#do_action('call', 'DefxCD')
	nnoremap <silent><buffer><expr> o     <SID>defx_my_toggle_tree()

	Shortcut! ^				(defx) cd defx to current
	Shortcut! =				(defx) cd vim to current
	Shortcut! o				(defx) open file and keep defx open

	Shortcut! <CR>    (defx) Toggle collapse/expand directory or open file
	Shortcut! e       (defx) Toggle collapse/expand directory or open file
	Shortcut! l       (defx) Toggle collapse/expand directory or open file
	Shortcut! h       (defx) Colapse directory tree
	Shortcut! t       (defx) Recursively open tree
	Shortcut! st      (defx) Open file in new tab
	Shortcut! sg      (defx) Open file in vertical split
	Shortcut! sv      (defx) Open file in horizontal split
	Shortcut! P       (defx) Preview file
	Shortcut! y       (defx) Yank selected item to clipboard
	Shortcut! x       (defx) Execute the file by system associated command
	Shortcut! gx      (defx) Execute the file by system associated command
	Shortcut! .       (defx) Toggle the enable state of ignored files

	" Shortcut! q       (defx) quit
 "  Shortcut! se      (defx) save session
	" Shortcut! <C-r>   (defx) redraw
	" Shortcut! <C-g>   (defx) print
	" Shortcut! c       (defx) copy
	" Shortcut! m       (defx) move
	" Shortcut! p       (defx) print
	" Shortcut! dd      (defx) send to trash
	" Shortcut! K			  (defx) create new directory
	" Shortcut! N       (defx) create new files and directories if provided. If the input ends with /", it means new directory"
	"
	" Shortcut! [g      (defx) previous dirty git item
	" Shortcut! ]g      (defx) next dirty git item
	"
	" Shortcut! \       (defx) move to vim root
	" Shortcut! &       (defx) move to vim root
	" Shortcut! <BS>    (defx) move to parent directory
	" Shortcut! ~       (defx) move to home directory
	" Shortcut! u       (defx) move up a directory
	" Shortcut! 2u      (defx) move up 2 directories
	" Shortcut! 3u      (defx) move up 3 directories
	" Shortcut! 4u      (defx) move up 4 directories
	"
	" Shortcut! *       (defx) invert selection (select all)
	" Shortcut! <Space> (defx) (un)select file or directory
	"
	" Shortcut! S       (defx) toggle sort by time
	"
	" Shortcut! w       (defx) toggle width
	" Shortcut! gd      (defx) open git diff on selected file
	" Shortcut! gr      (defx) grep in selected directory
	" Shortcut! gf      (defx) find files in selected directory
	" Shortcut! gl      (defx) open terminal file explorer
 endfunction

" Set the vim directory to the selected
function! g:DefxCD(context) abort
	let l:target = a:context['targets'][0]
	let l:selected = fnamemodify(l:target, ':p:h')
	silent execute 'close'
	silent execute 'cd '.l:selected
	echo 'cd set to '.l:selected
endfunction

function! s:defx_my_toggle_tree() abort
	" Open current file, or toggle directory expand/collapse
	if defx#is_directory()
		return defx#do_action('open_or_close_tree')
	endif
	return defx#do_action('drop')
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
let g:neomake_virtualtext_current_error = 0

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
