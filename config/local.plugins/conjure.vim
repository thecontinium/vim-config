
let g:conjure#mapping#prefix = ","
let g:conjure#mapping#log_split = "lv"
let g:conjure#mapping#log_vsplit = "lg"
let g:conjure#log#hud#width = 1
let g:conjure#log#hud#anchor = "SE"

autocmd user_events FileType clojure
  \ if &buftype == 'nofile' && bufname() =~ 'conjure-log'
  \ |   nnoremap <silent><buffer> q :<C-u>lua require('conjure.log')['close-visible']()<CR>
  \ | endif
