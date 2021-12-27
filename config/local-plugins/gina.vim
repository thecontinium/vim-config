lua require('plugins.gina')

function! s:get_extension(host) abort
	return { a:host : [
									\   [
									\     '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
									\     '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
									\     '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
									\     '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
									\   ], {
									\     'root':  'https://github.com/\2/\3/tree/%r1/',
									\     '_':     'https://github.com/\2/\3/blob/%r1/%pt%{#L|}ls%{-}le',
									\     'exact': 'https://github.com/\2/\3/blob/%h1/%pt%{#L|}ls%{-}le',
									\   },
									\ ]}
endfunction

call extend(g:gina#command#browse#translation_patterns, s:get_extension('the\.continium'))
call extend(g:gina#command#browse#translation_patterns, s:get_extension('mn\.dimension'))

" call gina#custom#command#option(
"       \ '/\%(commit\|tag\)',
"       \ '--restore'
"       \)

" call gina#custom#command#option(
"       \ '/\%(commit\|status\)',
"       \ '--group=comst'
"       \)
" call gina#custom#mapping#nmap(
"       \ 'status', '<C-^>',
"       \ ':<C-u>Gina commit<CR>',
"       \ {'noremap': 1, 'silent': 1}
"       \)
" call gina#custom#mapping#nmap(
"       \ 'commit', '<C-^>',
"       \ ':<C-u>Gina status<CR>',
"       \ {'noremap': 1, 'silent': 1}
"       \)
" call gina#custom#mapping#nmap(
"       \ 'status', '<C-6>',
"       \ ':<C-u>Gina commit<CR>',
"       \ {'noremap': 1, 'silent': 1}
"       \)
" call gina#custom#mapping#nmap(
"       \ 'commit', '<C-6>',
"       \ ':<C-u>Gina status<CR>',
"       \ {'noremap': 1, 'silent': 1}
"       \)

" call gina#custom#mapping#nmap(
"      \ '/\%(blame\|log\|reflog\)',
"      \ 'c',
"      \ ':<C-u>call gina#action#call(''compare'')<CR>',
"      \ {'noremap': 1, 'silent': 1}
"      \)

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
