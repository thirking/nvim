" Basics
set showmode


" Comments leader
augroup subsrc_comments
  autocmd!
  au BufEnter *.md setlocal fo=ctnqro com=b:>
  au BufEnter *.md exe 'syntax region markdownBlockquote start=/^\s*>/ end=/$/ contains=@Spell'
augroup end


" netrw
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_winsize = 80
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
nn  <silent> <leader>op :20Lexplore<CR>
tno <silent> <leader>op <C-\><C-N>:20Lexplore<CR>


" Pairs
let g:subrc_pairs_dict = {
      \ "("  : ")",
      \ "["  : "]",
      \ "{"  : "}",
      \ "'"  : "'",
      \ '"'  : '"',
      \ "`"  : "`",
      \ "*"  : "*",
      \ "**" : "**",
      \ "***": "***",
      \ "<u>": "</u>"
      \ }

function! s:util_get_context(arg) abort
  if a:arg ==# 'l'
    return matchstr(getline('.'), '.\%' . col('.') . 'c')
  elseif a:arg ==# 'n'
    return matchstr(getline('.'), '\%' . col('.') . 'c.')
  elseif a:arg ==# 'b'
    return matchstr(getline('.'), '^.*\%' . col('.') . 'c')
  elseif a:arg ==# 'f'
    return matchstr(getline('.'), '\%' . col('.') . 'c.*$')
  endif
endfunction

function! s:subrc_is_surrounded(match_list)
  return index(a:match_list, s:util_get_context('l') . s:util_get_context('n')) >= 0
endfunction

function! s:subrc_pairs_back()
  let l:back = s:util_get_context('b')
  let l:fore = s:util_get_context('f')
  if l:back =~ '\v\{\s$' && l:fore =~ '\v^\s\}'
    return "\<C-g>U\<Left>\<C-\>\<C-o>2x"
  endif
  let l:res = [0, 0, 0]
  for [key, val] in items(g:subrc_pairs_dict)
    let l:key_esc = '\v' . escape(key, ' ()[]{}<>*') . '$'
    let l:val_esc = '\v^' . escape(val, ' ()[]{}<>*')
    if l:back =~ l:key_esc && l:fore =~ l:val_esc && 
     \ len(key) + len(val) > l:res[1] + l:res[2]
      let l:res = [1, len(key), len(val)]
    endif
  endfor
  return l:res[0] ?
        \ repeat("\<C-g>U\<Left>", l:res[1]) .
        \ "\<C-\>\<C-o>" . (l:res[1] + l:res[2]) . "x" :
        \ "\<BS>"
endfunction

ino ( ()<C-g>U<Left>
ino [ []<C-g>U<Left>
ino { {}<C-g>U<Left>
ino <expr> ) <SID>util_get_context('n') ==# ")" ? g:const_dir_r : ")"
ino <expr> ] <SID>util_get_context('n') ==# "]" ? g:const_dir_r : "]"
ino <expr> } <SID>util_get_context('n') ==# "}" ? g:const_dir_r : "}"
ino <expr> "
      \ <SID>util_get_context('n') ==# "\"" ?
      \ g:const_dir_r : or(<SID>util_get_context('l') =~ '\v[\\''"]', col('.') == 1) ?
      \ '"' : '""' . g:const_dir_l
ino <expr> '
      \ <SID>util_get_context('n') ==# "'" ?
      \ g:const_dir_r : <SID>util_get_context('l') =~ '\v[''"]' ?
      \ "'" : "''" . g:const_dir_l
ino <expr> <SPACE>
      \ <SID>subrc_is_surrounded(['{}']) ?
      \ "\<SPACE>\<SPACE>" . g:const_dir_l : "\<SPACE>"
ino <expr> <BS> <SID>subrc_pairs_back()
"" Markdown
ino <expr> <M-P> "``" . g:const_dir_l
ino <expr> <M-I> "**" . g:const_dir_l
ino <expr> <M-B> "****" . repeat(g:const_dir_l, 2)
ino <expr> <M-M> "******" . repeat(g:const_dir_l, 3)
ino <expr> <M-U> "<u></u>" . repeat(g:const_dir_l, 4)


" Completion
" Key maps
"" Completion
ino <silent><expr> <CR>
      \ pumvisible() ? "\<C-y>" :
      \ <SID>subrc_is_surrounded(['()', '[]', '{}']) ?
      \ "\<CR>\<C-o>O" :
      \ "\<CR>"
ino <silent><expr> <TAB>
      \ or(<SID>util_get_context('l') =~ '\v[a-z_\u4e00-\u9fa5]', pumvisible()) ?
      \ "\<C-n>" : <SID>util_get_context('b') =~ '\v^\s*(\+\|-\|*\|\d+\.)\s$' ?
      \ "\<C-o>V>" . repeat(g:const_dir_r, &ts) : "\<TAB>"
ino <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"