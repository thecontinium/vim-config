" https://github.com/rafi/vim-config
" Maintainer: Rafael Bodill

function! s:str2list(expr) abort
	" Convert string to list
	return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction

function! s:error(msg) abort
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[vim-etc] ' . l:mes | echohl None
	endfor
endfunction

function! s:ensure_directory(paths) abort
	for l:path in s:str2list(a:paths)
		if ! isdirectory(l:path)
			call mkdir(l:path, 'p')
		endif
	endfor
endfunction

function! s:dein_init() abort
	" Use dein as a plugin manager and intialize all plugins
	let g:dein#auto_recache = 1
	let g:dein#install_max_processes = 16
	let g:dein#install_progress_type = 'echo'
	let g:dein#enable_notification = 0
	let g:dein#install_log_filename = g:cache_path . '/dein.log'

	" Add dein to vim's runtimepath
	let l:cache_path = g:cache_path . '/dein'
	if &runtimepath !~# '/dein.vim'
		let s:dein_dir = l:cache_path . '/repos/github.com/Shougo/dein.vim'
		" Clone dein if first-time setup
		if ! isdirectory(s:dein_dir)
			execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
			if v:shell_error
				call etc#util#error('dein installation has failed!')
				finish
			endif
		endif

		execute 'set runtimepath+='.substitute(
			\ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
	endif

	" Initialize dein.vim (package manager)
	if dein#load_state(l:cache_path)

		" Start propagating file paths and plugin presets
		call dein#begin(l:cache_path)

		call dein#add('Shougo/deoplete.nvim')
		let g:deoplete#enable_at_startup = 1
		call dein#add('Shougo/neosnippet.vim')
		call dein#add('Shougo/neosnippet-snippets')
		imap <C-k>     <Plug>(neosnippet_expand_or_jump)
		smap <C-k>     <Plug>(neosnippet_expand_or_jump)
		xmap <C-k>     <Plug>(neosnippet_expand_target)
		
		call dein#end()

		" Save cached state for faster startups
		if ! g:dein#_is_sudo
			call dein#save_state()
		endif

		" Update or install plugins if a change detected
		if dein#check_install()
			if ! has('nvim')
				set nomore
			endif
			call dein#install()
		endif
	endif

	filetype plugin indent on

	" Only enable syntax when vim is starting
	if has('vim_starting')
		syntax enable
	else
		" Trigger source events, only when vimrc is refreshing
		call dein#call_hook('source')
		call dein#call_hook('post_source')
	endif
endfunction

" Runtime and Plugins
" ===

if &compatible
	" vint: -ProhibitSetNoCompatible
	set nocompatible
	" vint: +ProhibitSetNoCompatible
endif

" Set main configuration directory as parent directory
let $VIM_PATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

let g:vim_path =
	\ get(g:, 'vim_path',
	\   ! empty($VIM_PATH) ? expand($VIM_PATH) :
	\   expand('$HOME/.vim')
	\ )

if &runtimepath !~# $VIM_PATH
	set runtimepath^=$VIM_PATH
endif

let g:cache_path =
	\ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache').'/vim')

let $DATA_PATH = g:cache_path

" Search and use environments specifically made for Neovim.
if isdirectory(g:cache_path.'/venv/neovim2')
	let g:python_host_prog = g:cache_path.'/venv/neovim2/bin/python'
endif
if isdirectory(g:cache_path.'/venv/neovim3')
	let g:python3_host_prog = g:cache_path.'/venv/neovim3/bin/python'
endif

" Set augroup
augroup user_events
	autocmd!
augroup END

" Disable vim distribution plugins
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:netrw_nogx = 1 " disable netrw's gx mapping.
let g:loaded_rrhelper = 1
let g:loaded_shada_plugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" Initialize base requirements
if has('vim_starting')
	" Global Mappings "{{{
	" Use spacebar as leader and ; as secondary-leader
	" Required before loading plugins!
	let g:mapleader="\<Space>"
	let g:maplocalleader=';'

	" Release keymappings prefixes, evict entirely for use of plug-ins.
	nnoremap <Space>  <Nop>
	xnoremap <Space>  <Nop>
	nnoremap ,        <Nop>
	xnoremap ,        <Nop>
	nnoremap ;        <Nop>
	xnoremap ;        <Nop>

	if ! has('nvim') && has('pythonx')
		if has('python3')
			set pyxversion=3
		elseif has('python')
			set pyxversion=2
		endif
	endif

	" Ensure data directories
	call s:ensure_directory([
		\   g:cache_path . '/undo',
		\   g:cache_path . '/backup',
		\   g:cache_path . '/session',
		\   g:vim_path . '/spell'
		\ ])

endif

" Load user scripts with confidential information
" or pre-settings like g:elite_mode

" Initialize plugin-manager and load main config files
call s:dein_init()

let g:deoplete#enable_at_startup = 1
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#enable_completed_snippet = 1
"let g:neosnippet#enable_complete_done = 1
let g:neosnippet#expand_word_boundary = 1
let g:neosnippet#enable_auto_clear_markers = 1
autocmd user_events InsertLeave * NeoSnippetClearMarkers

" Trigger colorscheme events when vimrc is reloaded within vim
if ! has('vim_starting')
	doautocmd ColorScheme
endif

set secure

" vim: set ts=2 sw=2 tw=80 noet :
