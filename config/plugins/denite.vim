
" denite.nvim
" -----------

" INTERFACE
call denite#custom#option('_', {
	\ 'empty': 0,
	\ 'auto_resume': 1,
	\ 'statusline': 0,
	\ 'start_filter': 1,
	\ 'vertical_preview': 1,
	\ 'prompt': '❯',
	\ 'highlight_window_background': 'CursorColumn',
	\ 'winwidth': &columns,
	\ 'winheight': &lines / 3,
	\ 'wincol': 0,
	\ 'winrow': (&lines - 3) - (&lines / 3),
	\ })

	"\ 'highlight_prompt': 'Function',
	"\ 'highlight_filter_background': 'CursorLine',

if has('nvim')
	call denite#custom#option('_', { 'split': 'floating' })
endif

" call denite#custom#option('search', { 'start_filter': 0, 'no_empty': 1 })
" call denite#custom#option('list', { 'start_filter': 0 })
" call denite#custom#option('jump', { 'start_filter': 0 })
" call denite#custom#option('gitview', { 'start_filter': 0 })

" MATCHERS
" Default is 'matcher/fuzzy'
" call denite#custom#source('tag', 'matchers', ['matcher/substring'])
call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])

" SORTERS
" Default is 'sorter/rank'
" call denite#custom#source('file/rec,grep', 'sorters', ['sorter/sublime'])
" call denite#custom#source('_', 'sorters', ['sorter/fruzzy'])
call denite#custom#source('z', 'sorters', ['sorter_z'])

" CONVERTERS
" Default is none
call denite#custom#source(
	\ 'buffer,file_mru,file_old',
	\ 'converters', ['converter_relative_word'])

" FIND and GREP COMMANDS
if executable('ag')
	" The Silver Searcher
	call denite#custom#var('file/rec', 'command',
		\ ['ag', '-U', '--hidden', '--follow', '--nocolor', '--nogroup', '-g', ''])

	" Setup ignore patterns in your .agignore file!
	" https://github.com/ggreer/the_silver_searcher/wiki/Advanced-Usage

	call denite#custom#var('grep', 'command', ['ag'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', [])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'default_opts',
		\ [ '--skip-vcs-ignores', '--vimgrep', '--smart-case', '--hidden' ])

elseif executable('ack')
	" Ack command
	call denite#custom#var('grep', 'command', ['ack'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--match'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'default_opts',
			\ ['--ackrc', $HOME.'/.config/ackrc', '-H',
			\ '--nopager', '--nocolor', '--nogroup', '--column'])

elseif executable('rg')
	" Ripgrep
	call denite#custom#var('file/rec', 'command',
		\ ['rg', '--files', '--glob', '!.git'])
	call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'default_opts',
		\ ['-i', '--vimgrep', '--no-heading'])
endif

" KEY MAPPINGS
augroup user_plugin_denite
	autocmd!

	autocmd VimResized * call denite#custom#option('_', {
		\   'winwidth': &columns,
		\   'winheight': &lines / 3,
		\   'winrow': (&lines - 3) - (&lines / 3),
		\ })

	autocmd FileType denite call s:denite_settings()

	autocmd FileType denite-filter call s:denite_filter_settings()
augroup END

function! s:denite_settings() abort
	setlocal signcolumn=no cursorline
	let b:coc_enabled = 0
	" highlight! CursorLine ctermbg=234 guibg=#1c1c1c
	highlight! link CursorLine Visual

	nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
	nnoremap <silent><buffer><expr> i    denite#do_map('open_filter_buffer')
	nnoremap <silent><buffer><expr> /    denite#do_map('open_filter_buffer')
	nnoremap <silent><buffer><expr> dd   denite#do_map('do_action', 'delete')
	nnoremap <silent><buffer><expr> p    denite#do_map('do_action', 'preview')
	nnoremap <silent><buffer><expr> st   denite#do_map('do_action', 'tabopen')
	nnoremap <silent><buffer><expr> sg   denite#do_map('do_action', 'vsplit')
	nnoremap <silent><buffer><expr> sv   denite#do_map('do_action', 'split')
	nnoremap <silent><buffer><expr> '    denite#do_map('quick_move')
	nnoremap <silent><buffer><expr> q    denite#do_map('quit')
	nnoremap <silent><buffer><expr> r    denite#do_map('redraw')
	nnoremap <silent><buffer><expr> yy   denite#do_map('do_action', 'yank')
	nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
	nnoremap <silent><buffer><expr> <Tab>   denite#do_map('choose_action')
	nnoremap <silent><buffer><expr><nowait> <Space> denite#do_map('toggle_select').'j'
endfunction

function! s:denite_filter_settings() abort
	setlocal signcolumn=no nocursorline
	call deoplete#custom#buffer_option('auto_complete', v:false)

	nnoremap <silent><buffer><expr> <Esc>  denite#do_map('quit')
	" inoremap <silent><buffer><expr> <Esc>  denite#do_map('quit')
	nnoremap <silent><buffer><expr> q      denite#do_map('quit')
	inoremap <silent><buffer><expr> <C-c>  denite#do_map('quit')
	nnoremap <silent><buffer><expr> <C-c>  denite#do_map('quit')
	inoremap <silent><buffer>       kk     <Esc><C-w>p
	nnoremap <silent><buffer>       kk     <C-w>p
	inoremap <silent><buffer>       jj     <Esc><C-w>p
	nnoremap <silent><buffer>       jj     <C-w>p
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
