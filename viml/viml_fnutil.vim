" Surround
"" Functions
function! s:util_sur_pair(pair_a)
  let l:pairs = { "(": ")", "[": "]", "{": "}", "<": ">", " ": " ", "《": "》", "“": "”" }
  if a:pair_a =~ '\v^(\(|\[|\{|\<|\s|《|“)+$'
    return join(reverse(map(split(a:pair_a, '\zs'), {idx, val -> l:pairs[val]})), '')
  elseif a:pair_a =~ '\v^(\<\w+\>)+$'
    return '</' . join(reverse(split(a:pair_a, '<')), '</')
  else
    return a:pair_a
  endif
endfunction

function! s:util_sur_add(mode, ...)
  let l:pair_a = a:0 ? a:1 : input("Surrounding add: ")
  let l:pair_b = s:util_sur_pair(l:pair_a)

  if a:mode ==# 'n'
    let l:org = getpos('.')
    if v:lua.lib_lua_get_context('f') =~ '\v^.\s' ||
     \ v:lua.lib_lua_get_context('f') =~ '\v^.$'
      exe "normal! a" . l:pair_b
    else
      exe "normal! Ea" . l:pair_b
    endif
    call setpos('.', l:org)
    if v:lua.lib_lua_get_context('l') =~ '\v\s' ||
     \ v:lua.lib_lua_get_context('b') =~ '\v^$'
      exe "normal! i" . l:pair_a
    else
      exe "normal! Bi" . l:pair_a
    endif
  elseif a:mode ==# 'v'
    let l:stt = [0] + getpos("'<")[1:2]
    let l:end = [0] + getpos("'>")[1:2]
    call setpos('.', l:end)
    exe "normal! a" . l:pair_b
    call setpos('.', l:stt)
    exe "normal! i" . l:pair_a
  endif
endfunction

function! s:util_sur_sub(...)
  let l:back = v:lua.lib_lua_get_context('b')
  let l:fore = v:lua.lib_lua_get_context('f')
  let l:pair_a = input("Surrounding delete: ")
  let l:pair_b = s:util_sur_pair(l:pair_a)
  let l:pair_a_new = a:0 ? a:1 : input("Change to: ")
  let l:pair_b_new = s:util_sur_pair(l:pair_a_new)
  let l:search_back = '\v.*\zs' . escape(l:pair_a, ' ()[]{}<>.+*')
  let l:search_fore = '\v' . escape(l:pair_b, ' ()[]{}<>.+*')

  if l:back =~ l:search_back && l:fore =~ l:search_fore
    let l:back_new = substitute(l:back, l:search_back, l:pair_a_new, '')
    let l:fore_new = substitute(l:fore, l:search_fore, l:pair_b_new, '')
    let l:line_new = l:back_new . l:fore_new
    call setline(line('.'), l:line_new)
  endif
endfunction
"" Common maps
nn <silent> <leader>sa :call <SID>util_sur_add('n')<CR>
vn <silent> <leader>sa :<C-u>call <SID>util_sur_add('v')<CR>
nn <silent> <leader>sd :call <SID>util_sur_sub('')<CR>
nn <silent> <leader>sc :call <SID>util_sur_sub()<CR>
"" Markdown maps
for [key, val] in items({'P':'`', 'I':'*', 'B':'**', 'M':'***', 'U':'<u>'})
  for mod_item in ['n', 'v']
    exe mod_item . 'n' '<silent> <M-' . key . '>'
          \ ':call <SID>util_sur_add("' . mod_item . '","' . val . '")<CR>'
  endfor
endfor


" Key maps
"" Windows-like behaviors
""" Save
nn  <silent> <C-s> :w<CR>
ino <silent> <C-s> <C-o>:w<CR>
""" Undo
nn  <silent> <C-z> u
ino <silent> <C-z> <C-o>u
""" Copy/Paste
vn  <silent> <M-c> "+y
vn  <silent> <M-x> "+x
nn  <silent> <M-v> "+p
vn  <silent> <M-v> "+p
ino <silent> <M-v> <C-R>=@+<CR>
""" Select
nn  <silent> <M-a> ggVG
ino <silent> <M-a> <Esc>ggVG
"" Search visual selection
vn  <silent> * y/\V<C-r>=v:lua.lib_lua_get_visual_selection()<CR><CR>
"" Echo git status
nn <silent> <leader>vs :!git status<CR>
"" Some emacs shit.
for [key, val] in items({"n": "j", "p": "k"})
  exe 'nn  <C-' . key . '> g' . val
  exe 'vn  <C-' . key . '> g' . val
  exe 'ino <silent> <C-' . key . '> <C-o>g' . val
endfor
nn  <M-x> :
ino <M-x> <C-o>:
ino <M-b> <C-o>b
ino <M-f> <C-o>e<Right>
ino <C-SPACE> <C-o>v
ino <silent> <C-a> <C-o>g0
ino <silent> <C-e> <C-o>g$
ino <silent><expr> <C-k> col('.') >= col('$') ? "" : "\<C-o>D"
ino <silent><expr> <M-d> col('.') >= col('$') ? "" : "\<C-o>dw"
ino <silent><expr> <C-f> col('.') >= col('$') ? "\<C-o>+" : g:lib_const_r
ino <silent><expr> <C-b> col('.') == 1 ? "\<C-o>-\<C-o>$" : g:lib_const_l
