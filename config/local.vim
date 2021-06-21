" Command & History {{{
" -----------------

" Switch history search pairs, matching my zsh shell
cnoremap <expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
cunmap <C-p>
cunmap <C-n>
" }}}
" Fern {{{
if dein#tap('fern.vim')
	augroup fern_global
		autocmd! *
		autocmd fern_global DirChanged * ++nested execute printf('FernDo Fern\ %s\ -drawer\ -stay -drawer -stay',deepcopy(v:event).cwd)
	augroup END
endif
" }}}
" Vista {{{
if dein#tap('vista.vim') &&	has('nvim-0.5')
	let g:vista_executive_for.clojure = 'nvim_lsp'
endif
" }}}
" Telescope {{{
if dein#tap('telescope.nvim')
	nnoremap <silent><LocalLeader>l :<C-u>Telescope lsp_code_actions theme=get_dropdown result_height=6 width=40<CR>
endif
" }}}
" Session Management {{{
" What to save in sessions:

let g:session_directory = expand('$HOME/Resilio Sync/app/vim/session')
" set sessionoptions+=winpos
" set sessionoptions+=buffers
" nmap <silent> <Leader>su :<C-u>let v:this_session='' && execute 'redrawtabline'<CR>
" nmap <silent> <Leader>su :<C-u>call g:SessionUnload()<CR>
" function! g:SessionUnload() abort
" 	let v:this_session=''
" 	silent execute 'redrawtabline'
" endfunction
" }}}
" Terminal Mappings {{{
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
" }}}
" Manage specific file type mappings {{{
augroup user_plugin_filetype " {{{ all
" set to default so that we get the warnings and options
" for manageing swap files
  autocmd swapexists * nested let v:swapchoice = ''
augroup END " }}}
augroup MyAutoCmd " {{{ markdown, vimwiki, clojure, yaml

" save automatically when text is changed
" it will save the current file whenever text is changed in normal mode
" or you leave the insert mode.
autocmd FileType markdown
  \ setlocal nospell path=. suffixesadd=.mmd
  \ | setlocal updatetime=200
  \ | au CursorHold <buffer> silent! update

if dein#tap('denite.vim')
	autocmd FileType vimwiki,markdown
		\ let b:sleuth_automatic = 0
		\ | setlocal concealcursor=nc
		\ | nnoremap <silent><buffer><LocalLeader>f :<C-u>DeniteBufferDir -sorters=sorter/lastmod file/rec grep:::!<CR>
endif

" only run vimwikireturn if the popup menu is not showing, otherwise close it
autocmd filetype vimwiki
  \ setlocal sw=4
  \ | setlocal sts=4
  \ | setlocal et
  "\ inoremap <silent><buffer><expr><CR> pumvisible() ?  asyncomplete#close_popup() : "<ESC>:VimwikiReturn 1 5<CR>"

autocmd FileType clojure
  \ let b:sleuth_automatic = 0
  \ | nnoremap <silent><buffer>,rl :<C-u>vsplit term://lein repl<CR>

autocmd FileType yaml
  \ let b:sleuth_automatic = 0

augroup END " }}}
" Clojure Settings {{{

if dein#tap('neosnippet.vim')
  smap <expr><C-o> neosnippet#expandable_or_jumpable()
    \ ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
endif

if dein#tap('vim-sexp')
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
end

if dein#tap('ale')
  nmap <silent> [c <Plug>(ale_previous)
  nmap <silent> ]c <Plug>(ale_next)
endif

" }}}
" Gina Settings {{{

if dein#tap('gina.vim')
  nnoremap <silent> <leader>gL :Gina log :<CR>
  " nnoremap <silent> <leader>ga :Gina add %:p<CR>
  " nnoremap <silent> <leader>gd :Gina compare -R<CR>
  " nnoremap <silent> <leader>gc :Gina commit<CR>
  " nnoremap <silent> <leader>gb :Gina blame<CR>
  " nnoremap <silent> <leader>gF :Gina fetch<CR>
  " nnoremap <silent> <leader>gS :Gina status<CR>
  " nnoremap <silent> <leader>gp :Gina push<CR>
endif
" }}}
" Easymotion Settings {{{

if dein#tap('vim-easymotion')
  " nmap ss <Plug>(easymotion-s2)
  " nmap sd <Plug>(easymotion-s)
  " nmap sf <Plug>(easymotion-overwin-f)
  " map  sh <Plug>(easymotion-linebackward)
  " map  sl <Plug>(easymotion-lineforward)
  " " map  sj <Plug>(easymotion-j)
  " " map  sk <Plug>(easymotion-k)
  " map  s/ <Plug>(easymotion-sn)
  " omap s/ <Plug>(easymotion-tn)
  " map  sn <Plug>(easymotion-next)
  " map  sp <Plug>(easymotion-prev)
endif
" }}}
" - vim-UnconditionalPaste Settings {{{

if dein#tap('vim-UnconditionalPaste')
  nmap Pc <Plug>UnconditionalPasteCharBefore
  nmap pc <Plug>UnconditionalPasteCharAfter
	nmap Pl <Plug>UnconditionalPasteLineBefore
	nmap pl <Plug>UnconditionalPasteLineAfter
endif
" }}}
" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
