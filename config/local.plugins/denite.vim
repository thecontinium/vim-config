" :h denite.txt
" ---
" Problems? https://github.com/Shougo/denite.nvim/issues

" Don't reload Denite twice (on vimrc reload)
if exists('*denite#start')
  finish
endif

source $VIM_PATH/config/plugins/denite.vim

function! s:dein_update(context) abort
  if a:context['targets'][0]['source_name'] ==# 'dein'
    call dein#update(split(a:context['targets'][0]['word'],'/')[1])
  endif
endfunction
call denite#custom#action('directory', 'dein_update', function('s:dein_update'))
call denite#custom#action('directory',
  \ 'cd', {context -> execute(printf('tcd %s', context['targets'][0]['action__path']))} )

augroup my_user_plugin_denite
  autocmd!
  autocmd FileType denite call s:denite_my_settings()
augroup END
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> sa denite#do_map('do_action', 'save')
endfunction
