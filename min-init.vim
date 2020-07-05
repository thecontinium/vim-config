if &compatible | set nocompatible | endif

" Set configuration paths
let $VIMRC_DIR = fnamemodify(expand($MYVIMRC), ':h')
let $BUNDLE_DIR = $VIMRC_DIR . '/bundle'
let $DEIN_DIR = $BUNDLE_DIR . '/repos/github.com/Shougo/dein.vim'
let g:python3_host_prog = $PYENV_ROOT . '/versions/neovim/bin/python'

" Install dein.vim
if ! isdirectory($DEIN_DIR)
	execute '!git clone https://github.com/Shougo/dein.vim' expand($DEIN_DIR)
endif
execute 'set runtimepath+='.substitute(
	\ fnamemodify($DEIN_DIR, ':p') , '/$', '', '')

" Add plugins to bundle
call dein#begin($BUNDLE_DIR, [ expand('<sfile>') ])
call dein#add('airblade/vim-gitgutter', { 'on_path': '.*' })
call dein#add('Olical/conjure', { 'rep': 'v1.*.*', 'build': 'bin/compile' })
call dein#add('Shougo/Defx.nvim')
call dein#end()

if dein#check_install()
	call dein#install()
endif

filetype plugin indent on
syntax enable
call defx#custom#option('_', {
	\ 'winwidth': 25,
	\ 'split': 'vertical',
	\ 'direction': 'topleft',
	\ 'show_ignored_files': 0,
	\ 'columns': 'indent:git:icons:filename',
	\ 'root_marker': ' ',
	\ 'ignored_files':
	\     '.mypy_cache,.pytest_cache,.git,.hg,.svn,.stversions'
	\   . ',__pycache__,.sass-cache,*.egg-info,.DS_Store,*.pyc'
	\ })

"	\ 'resume': 1,
