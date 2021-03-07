source $VIM_PATH/config/plugins/denite.vim

" Pre-processors
" ---

function! s:sort_by_priority_preprocessor(options, matches) abort
  let l:items = []
  for [l:source_name, l:matches] in items(a:matches)
    for l:item in l:matches['items']
      if stridx(l:item['word'], a:options['base']) == 0
				let l:item['priority'] =
					\ get(asyncomplete#get_source_info(l:source_name), 'priority', 1)
				call add(l:items, l:item)
      endif
    endfor
  endfor
  let l:items = sort(l:items, {a, b -> b['priority'] - a['priority']})
  call asyncomplete#preprocess_complete(a:options, l:items)
endfunction

let g:asyncomplete_preprocessor = [function('s:sort_by_priority_preprocessor')]

" vim: set ts=2 sw=2 tw=80 noet :
