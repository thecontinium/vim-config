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
call dein#add('windwp/nvim-autopairs', {'merged': 0, 'hook_post_source': "lua require('nvim-autopairs').setup()"} )
call dein#end()

if dein#check_install()
	call dein#install()
endif

lua require('nvim-autopairs').setup()
