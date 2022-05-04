
let g:conjure#mapping#prefix = ','
let g:conjure#mapping#log_split = 'lv' "ls
let g:conjure#mapping#log_toggle = 'ls' "lg
let g:conjure#mapping#log_vsplit = 'lg' "lv
let g:conjure#log#hud#width = 1
let g:conjure#log#hud#anchor = 'SE'
let g:conjure#highlight#enabled = v:true

autocmd user_events FileType clojure
  \ if &buftype == 'nofile' && bufname() =~ 'conjure-log'
  \ |   nnoremap <silent><buffer> q <Cmd>lua require('conjure.log')['close-visible']()<CR>
  \ | endif
