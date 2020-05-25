" Key Mappings {{{
" make sure that iTerm sends the right key combination for <S-Return>
" https://stackoverflow.com/questions/16359878/vim-how-to-map-shift-enter
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
" }}}
" Defx mappings {{{
autocmd user_events DirChanged * if bufwinnr('tab'.tabpagenr()) != -1
  \ |  let cw = winnr()
  \ |  Defx -toggle  -buffer-name=tab`tabpagenr()`
  \ |  execute('lcd ' . v:event['cwd'] )
	\ |  Defx -toggle `getcwd()` -buffer-name=tab`tabpagenr()`
  \ |  execute(cw .'wincmd w')
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

autocmd FileType vimwiki,markdown
  \ let b:sleuth_automatic = 0
  \ | setlocal concealcursor=nc
  \ | nnoremap <silent><buffer><LocalLeader>f :<C-u>DeniteBufferDir -sorters=sorter/lastmod file/rec grep:::!<CR>

" only run vimwikireturn if the popup menu is not showing, otherwise close it
autocmd filetype vimwiki
  \ inoremap <silent><buffer><expr><CR> pumvisible() ?  asyncomplete#close_popup() : "<ESC>:VimwikiReturn 1 5<CR>"
  \ | setlocal sw=4
  \ | setlocal sts=4
  \ | setlocal et

autocmd FileType clojure
  \ let b:sleuth_automatic = 0
  \ | nnoremap <silent><buffer>,rl :<C-u>vsplit term://lein repl<CR>

autocmd FileType yaml
  \ let b:sleuth_automatic = 0

augroup END " }}}
" }}}
" Which-Key {{{
let g:which_key_map = { 'name' : 'all' }
let g:which_key_map.a = 'which_key_ignore'
let g:which_key_map.A = 'which_key_ignore'
let g:which_key_map.i = 'which_key_ignore'
let g:which_key_map.I = 'which_key_ignore'
let g:which_key_map[';'] = { 'name' : 'local-leader' }
let g:which_key_map[','] = { 'name' : 'comma' }
let g:which_key_map[','].c = { 'name' : 'clojure-log' }
let g:which_key_map[','].e = { 'name' : 'clojure-eval' }
" }}}
" Shortcuts {{{
if dein#tap('vim-shortcut')

Shortcut show shortcut menu and run chosen shortcut
      \ noremap <silent> ,, :ShortcutsRangeless<Return>
Shortcut show shortcut menu
      \ nnoremap <silent><LocalLeader>' :<C-u>Denite shortcut<CR>
" Shortcuts for Denite {{{
Shortcut! ;r         (denite) Resumes last Denite window
Shortcut! ;f	     (denite) File search
Shortcut! ;b	     (denite) Buffers and MRU
Shortcut! ;d	     (denite) Directories
Shortcut! ;v	     (denite) Yank history
Shortcut! ;l	     (denite) Location list
Shortcut! ;q	     (denite) Quick fix
Shortcut! ;n	     (denite) Dein plugin list
Shortcut! ;g	     (denite) Grep search
Shortcut! ;j	     (denite) Jump points
Shortcut! ;u	     (denite) Junk files
Shortcut! ;o	     (denite) Outline tags
Shortcut! ;s	     (denite) Sessions
Shortcut! ;t	     (denite) Tag list
Shortcut! ;p	     (denite) Jump to previous position
Shortcut! ;h	     (denite) Help
Shortcut! ;m	     (denite) Memo list
Shortcut! ;z	     (denite) Z (jump around)
Shortcut! ;/	     (denite) Buffer lines
Shortcut! ;*	     (denite) Match word under cursor with lines
Shortcut! ;;	     (denite) Command history
Shortcut! <leader>gl (denite) Git log (all)
Shortcut! <leader>gs (denite) Git status
Shortcut! <leader>gc (denite) Git branches
Shortcut! <leader>gt (denite) Find tags matching word under cursor
Shortcut! <leader>gf (denite) Find file matching word under cursor
Shortcut! <leader>gg (denite) Grep word under cursor
Shortcut! jj	     (denite-window) Leave Insert mode
Shortcut! kk	     (denite-window) Leave Insert mode
Shortcut! q        (denite-window) Exit denite window
Shortcut! <Escape> (denite-window) Exit denite window
Shortcut! Space    (denite-window) Select entry
Shortcut! Tab     (denite-window) List and choose action
Shortcut! i        (denite-window) Open filter input
Shortcut! dd	     (denite-window) Delete entry
Shortcut! p        (denite-window) Preview entry
Shortcut! st       (denite-window) Open in a new tab
Shortcut! sg       (denite-window) Open in a vertical split
Shortcut! sv       (denite-window) Open in a split
Shortcut! r        (denite-window) Redraw
Shortcut! yy       (denite-window) Yank
Shortcut! '        (denite-window) Quick move
Shortcut! sa       (denite-window) Save

" Actions of gitlog:

" open default action for open seleted commit.
" preview preview seleted commit.
" delete run git diff with current commit for current buffer. (just named delete)
" reset run git reset with current commit.
" Actions of gitstatus:
"
" open open seleted file, default action
" add run git add for seleted file(s).
" delete run git diff for seleted file. (just named delete)
" reset run git reset/checkout or remove for seleted file(s).
" commit run git commit for seleted file(s).
" Actions of gitbranch:
"
" checkout default action to checkout selected branch.
" delete delete seleted branch.
" merge merge seleted branch with current branch.
" rebase rebase seleted branch with current branch.
" Actions of gitfiles:
"
" view default action to view a file at a certain commit (read-only)
" Shortcuts for Easy Git
"}}}
" Shortcuts for easy git {{{
Shortcut! <leader>ga (easy-git) Git add current file
Shortcut! <leader>gS (easy-git) Git status
Shortcut! <leader>gd (easy-git) Git diff
Shortcut! <leader>gD (easy-git) Close diff
Shortcut! <leader>gc (easy-git) Git commit
Shortcut! <leader>gb (easy-git) Git blame
Shortcut! <leader>gB (easy-git) Open in browser
Shortcut! <leader>gp (easy-git) Git push
" }}}
" Shortcuts for Git Gutter {{{
Shortcut! [g         (git-gutter) Jump to next hunk
Shortcut! ]g         (git-gutter) Jump to previous hunk
Shortcut! gS         (git-gutter) Stage hunk
Shortcut! <leader>gr (git-gutter) Revert hunk
Shortcut! gs         (git-gutter) Preview hunk
" }}}
" Shortcuts for Signature {{{
Shortcut! m//?         (signature) Show list of buffer marks/markers
Shortcut! mm           (signature) Toggle mark on current line
Shortcut! m,           (signature) Place next mark
Shortcut! m[a-z]       (signature) Place specific mark (Won't work for: `m`, `n`, `p`)
Shortcut! dm+[a-z]     (signature) Remove specific mark (Won't work for: `m`, `n`, `p`)
Shortcut! mn           (signature) Jump to next mark
Shortcut! mp           (signature) Jump to previous mark
Shortcut! ]=           (signature) Jump to next marker
Shortcut! [=           (signature) Jump to previous marker
Shortcut! m-           (signature) Purge all on current line
Shortcut! m<Space>     (signature) Purge marks
Shortcut! m<Backspace> (signature) Purge markers
" }}}
" Shortcuts for Window and Buffer {{{
Shortcut! sv  (window-buffer) horizontal split
Shortcut! sg  (window-buffer) vertical split
Shortcut! st  (window-buffer) open new tab
Shortcut! so  (window-buffer) only this window
Shortcut! sb  (window-buffer) previous buffer
Shortcut! sc  (window-buffer) close current buffer
Shortcut! sx  (window-buffer) remove buffer
Shortcut! ssv (window-buffer) horizontal split with previous buffer
Shortcut! ssg (window-buffer) vertical split with previous buffer
Shortcut! sh  (window-buffer) toggle background
Shortcut! s-  (window-buffer) contrast down
Shortcut! s=  (window-buffer) contrast up
" }}}
" Shortcuts for defx {{{
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

Shortcut! q       (defx) quit
Shortcut! se      (defx) save session
Shortcut! <C-r>   (defx) redraw
Shortcut! <C-g>   (defx) print
Shortcut! c       (defx) copy
Shortcut! m       (defx) move
Shortcut! p       (defx) paste
Shortcut! r       (defx) rename
Shortcut! dd      (defx) send to trash
Shortcut! K			  (defx) create new directory
Shortcut! N       (defx) create new files and directories if provided. If the input ends with /", it means new directory"

Shortcut! [g      (defx) previous dirty git item
Shortcut! ]g      (defx) next dirty git item

Shortcut! \       (defx) move to vim root
Shortcut! &       (defx) move to vim root
Shortcut! <BS>    (defx) move to parent directory
Shortcut! ~       (defx) move to home directory
Shortcut! u       (defx) move up a directory
Shortcut! 2u      (defx) move up 2 directories
Shortcut! 3u      (defx) move up 3 directories
Shortcut! 4u      (defx) move up 4 directories

Shortcut! *       (defx) invert selection (select all)
Shortcut! <Space> (defx) (un)select file or directory

Shortcut! S       (defx) toggle sort by time

Shortcut! w       (defx) toggle width
Shortcut! gd      (defx) open git diff on selected file
Shortcut! gr      (defx) grep in selected directory
Shortcut! gf      (defx) find files in selected directory
Shortcut! gl      (defx) open terminal file explorer
" }}}
" Shourcuts for clojure {{{
Shortcut! ,i  (sexp) round head wrap list; surround the current form with () and places the cursor at the front
Shortcut! ,I  (sexp) round tail wrap list; surround the current form with () and places the cursor at the end
Shortcut! ,w  (sexp) round head wrap element; surround the current element with () and place the cursor at the front
Shortcut! ,W  (sexp) round tail wrap element; surround the current element with () and place the cursor at the end
Shortcut! ,h  (sexp) insert at list head
Shortcut! ,l  (sexp) insert at list tail
Shortcut! ,@  (sexp) splice list, splices the current form into its parent: (1 (2 3) 4) => (1 2 3 4)
Shortcut! ,?  (sexp) convolute
Shortcut! ,o  (sexp) raise list,replaces the parent form with the current form: o in the middle of (1 (2 3) 4) => (2 3)
Shortcut! ,O  (sexp) raise_element, replaces the parent form with the current element: O on 2 in (1 (2 3) 4) => (1 2 4)

" mappings for regular people
Shortcut! >f  (sexp) move a form, swap or move the current form right: >f on 2 of (1 (2 3) 4) => (1 4 (2 3))
Shortcut! <f  (sexp) move a form, swap or move the current form left: <f on 2 of (1 4 (2 3)) => (1 (2 3) 4)
Shortcut! >e  (sexp) move a form
Shortcut! <e  (sexp) move a form
Shortcut! >)  (sexp) slurp right; move the corresponding parentheses to the right: >) in the inner form of (1 (2 3) 4) => (1 (2 3 4))
Shortcut! <(  (sexp) slurp left; move the corresponding parentheses to the left: <( in the inner form of (1 (2 3) 4) => ((1 2 3) 4))
Shortcut! >(  (sexp) burp right; move the parentheses: >( in the inner form of (1 (2 3) 4) => (1 2 (3) 4)
Shortcut! <(  (sexp) burp left; move the parentheses: <( in the inner form of (1 (2 3) 4) => ((1 2 3) 4)
Shortcut! >I  (sexp) insert at the begining of the form
Shortcut! <I  (sexp) insett at the end of the form

Shortcut! ,cu  (conjure) Synchronise connections with your `.conjure.edn` config files, takes flags like `-foo +bar` which will set the `:enabled?` flags of matching connections
Shortcut! ,cs  (conjure) Display the current connections in the log buffer
Shortcut! ,ew  (conjure) (word under cursor) Evaluate the argument in the appropriate prepl
Shortcut! ,ee  (conjure) (visual mode) Evaluates the current (or previous) visual selection
Shortcut! ,ee  (conjure) Evaluates the form under the cursor
Shortcut! ,er  (conjure) Evaluates the outermost form under the cursor|
Shortcut! ,em  (conjure) {KEY} Jump to the mark denoted by the {KEY} you press, evaluate the form found there and then jump back to where you started
Shortcut! ,eb  (conjure) Evaluate the entire buffer (not from the disk)
Shortcut! ,ef  (conjure) Load and evaluate the file from the disk
Shortcut! K    (conjure) Display the documentation for the given symbol in the log buffer
Shortcut! ,ss  (conjure) Display the source for the given symbol in the log buffer
Shortcut! gd   (conjure) Go to the source of the given symbol, providing we can find it - falls back to vanilla `gd`
Shortcut! ,cl  (conjure) Open and focus the log buffer in a large window
Shortcut! ,cq  (conjure) Close the log window if it's open in this tab
Shortcut! ,cL  (conjure) Open or close the log depending on it's current state
Shortcut! ,tt  (conjure) Run tests in the current namespace and it's `-test` equivalent (as well as the other way around) or with the provided namespace names separated by spaces. |
Shortcut! ,ta  (conjure) Run all tests with an optional namespace filter regex. |
Shortcut! ,rr  (conjure) Clojure only, refresh changed namespaces
Shortcut! ,rR  (conjure) Clojure only, refresh all namespaces
Shortcut! ,rC  (conjure) Clojure only, refresh clen namespaces
Shortcut! ,rl  (clojure) open a lein repl in a new buffer
endif
" }}}
" }}}
" Defx Settings {{{
autocmd MyAutoCmd FileType defx call <SID>defx_my_settings()

function! s:defx_my_settings() abort
  " nnoremap <silent><buffer><expr><nowait> ^  defx#do_action('cd', defx#get_candidate().action__path)
  " nnoremap <silent><buffer><expr>					=  defx#do_action('call', '<SID>defx_cd')
  nnoremap <silent><buffer><expr>					o  <SID>defx_my_toggle_tree()
  nnoremap <silent><buffer><expr>					U  defx#do_action('call', '<SID>defx_open_scm')
endfunction

function! s:defx_open_scm(context) abort
  let l:target = a:context['targets'][0]
  let l:selected = fnamemodify(l:target, ':~:.')
  silent execute 'OpenSCM '.l:selected
endfunction

" Set the vim directory to the selected
function! s:defx_cd(context) abort
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
"}}}
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
endif
" }}}
" Gina Settings {{{

if dein#tap('gina.vim')
	nnoremap <silent> <leader>ga :Gina add %:p<CR>
	nnoremap <silent> <leader>gd :Gina compare -R<CR>
	nnoremap <silent> <leader>gc :Gina commit<CR>
	nnoremap <silent> <leader>gb :Gina blame<CR>
	nnoremap <silent> <leader>gF :Gina fetch<CR>
	nnoremap <silent> <leader>gS :Gina status<CR>
	nnoremap <silent> <leader>gp :Gina push<CR>
endif

" }}}
" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
