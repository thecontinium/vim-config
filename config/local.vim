" Command & History {{{
" -----------------

"dein {{{ see help
autocmd VimEnter * call dein#call_hook('post_source')
"}}}
" Switch history search pairs, matching my zsh shell {{{
cnoremap <expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
cunmap <C-p>
cunmap <C-n>
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
" Editor UI {{{
" Toggle editor's visual effects
nmap <Leader>tr <cmd>setlocal relativenumber!<CR>
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
" markdown filetype file
au BufRead,BufNewFile *.{mmd} set filetype=markdown
" autocmd FileType markdown
"   \ setlocal nospell path=. suffixesadd=.mmd
"   \ | setlocal updatetime=200
"   \ | au CursorHold <buffer> silent! update

autocmd FileType vimwiki,markdown
  \ let b:sleuth_automatic = 0
  \ | setlocal concealcursor=nc
  "\ | nnoremap <silent><buffer><LocalLeader>f :<C-u>DeniteBufferDir -sorters=sorter/lastmod file/rec grep:::!<CR>

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
" }}}
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
	  \ 'sexp_splice_list':               ',d',
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
endif
" }}}
" auto-session settings {{{
if dein#tap('auto-session')
	set wildignore-=%*
endif
" }}}
" - vim-UnconditionalPaste Settings {{{
if dein#tap('vim-UnconditionalPaste')
  nmap Pc <Plug>UnconditionalPasteCharBefore
  nmap pc <Plug>UnconditionalPasteCharAfter
	nmap Pl <Plug>UnconditionalPasteLineBefore
  nmap pl <Plug>UnconditionalPasteLineAfter
	if dein#tap('which-key')
lua << EOF
local wk = require("which-key")
wk.register({c="which_key_ignore", l="which_key_ignore"},{prefix ="p"})
wk.register({c="which_key_ignore", l="which_key_ignore"},{prefix ="P"})
EOF
	endif
endif
" }}}
" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
