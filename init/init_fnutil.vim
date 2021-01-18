" Variables
"" OS
if has("win32")
  let g:util_def_start = 'start'
  let g:util_def_terminal = 'powershell.exe -nologo'
  let g:util_def_cc = 'gcc'
  let g:python3_host_prog = $HOME . '/Appdata/Local/Programs/Python/Python38/python.EXE'
  set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
  set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
  set wildignore+=*.pyc
  set wildignore+=*.DS_Store
  set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz
elseif has("unix")
  let g:util_def_start = 'xdg-open'
  let g:util_def_terminal = 'bash'
  let g:util_def_cc = 'gcc'
  let g:python3_host_prog = '/usr/bin/python3'
  set wildignore+=*.so
elseif has("mac")
  let g:util_def_start = 'open'
  let g:util_def_cc = 'clang'
endif
"" Search web
let s:util_web_list = {
      \ "b" : "https://www.baidu.com/s?wd=",
      \ "g" : "https://www.google.com/search?q=",
      \ "h" : "https://github.com/search?q=",
      \ "y" : "https://dict.youdao.com/w/eng/"
      \ }


" Functions
"" Mouse toggle
function! s:util_mouse_toggle()
  if &mouse == 'a'
    set mouse=
    echom "Mouse disabled"
  else
    set mouse=a
    echom "Mouse enabled"
  endif
endfunction

"" Background toggle
function! s:util_bg_toggle()
  let &background = (&background == 'dark' ? 'light' : 'dark')
  if exists("g:colors_name")
    exe 'colorscheme' g:colors_name
  endif
endfunction

"" Open terminal
function! s:util_terminal()
  call Lib_Belowright_Split(15)
  exe ':terminal' g:util_def_terminal
endfunction

"" Open file manager
function! s:util_explorer()
  silent exe '!' . g:util_def_start '.'
endfunction

"" Open pdf file
function! s:util_pdf_view(...)
  if a:0 > 0
    let l:name = a:1
  else
    let l:name = expand('%:r') . '.pdf'
  endif
  silent exe '!' . g:util_def_start l:name
endfunction

"" Surround
function! s:util_sur_pair(pair_a)
  let l:pairs = { "(": ")", "[": "]", "{": "}", "<": ">" }
  if has_key(l:pairs, a:pair_a)
    return l:pairs[a:pair_a]
  elseif a:pair_a =~ '\v^\<\w+\>$'
    return substitute(a:pair_a, '\v^(\<)', '</', '')
  else
    return a:pair_a
  endif
endfunction

function! s:util_sur_add(mode, pair_a)
  let l:pair_a = a:pair_a
  let l:pair_b = s:util_sur_pair(l:pair_a)

  if a:mode ==# 'n'
    exe "normal! Ea" . l:pair_b
    exe "normal! Bi" . l:pair_a
  elseif a:mode ==# 'v'
    let l:stt = [0] + getpos("'<")[1:2]
    let l:end = [0] + getpos("'>")[1:2]
    call setpos('.', l:end)
    exe "normal! a" . l:pair_b
    call setpos('.', l:stt)
    exe "normal! i" . l:pair_a
  endif
endfunction

function! s:util_sur_del(pair_a)
  let l:back = Lib_Get_Char('b')
  let l:fore = Lib_Get_Char('f')
  let l:pair_a = a:pair_a
  let l:pair_b = s:util_sur_pair(l:pair_a)
  let l:search_back = '\v.*\zs' . escape(l:pair_a, ' ()[]{}<>.+*')
  let l:search_fore = '\v' . escape(l:pair_b, ' ()[]{}<>.+*')

  if l:back =~ l:search_back && l:fore =~ l:search_fore
    let l:back_new = substitute(l:back, l:search_back, '', '')
    let l:fore_new = substitute(l:fore, l:search_fore, '', '')
    let l:line_new = l:back_new . l:fore_new
    call setline(line('.'), l:line_new)
  endif
endfunction

"" Hanzi count.
function! s:util_hanzi_count(mode)
  if a:mode ==? "n"
    let l:content = readfile(expand('%:p'))
    let l:h_count = 0
    for line in l:content
      for char in split(line, '.\zs')
        if Lib_Is_Hanzi(char) | let l:h_count += 1 | endif
      endfor
    endfor
    return l:h_count
  elseif a:mode ==? "v"
    let l:select = split(Lib_Get_Visual_Selection(), '.\zs')
    let l:h_count = 0
    for char in l:select
      if Lib_Is_Hanzi(char) | let l:h_count += 1 | endif
    endfor
    return l:h_count
  else
    echom "Invalid mode argument."
  endif
endfunction

"" Search web
function! s:util_search_web(mode, site)
  let l:del_list = [
        \ ".", ",", "'", "\"",
        \ ";", "*", "~", "`", 
        \ "(", ")", "[", "]", "{", "}"
        \ ]
  if a:mode ==? "n"
    let l:search_obj = Lib_Str_Escape(Lib_Get_Clean_CWORD(l:del_list), g:lib_const_esc_url)
  elseif a:mode ==? "v"
    let l:search_obj = Lib_Str_Escape(Lib_Get_Visual_Selection(), g:lib_const_esc_url)
  endif
  let l:url_raw = s:util_web_list[a:site] . l:search_obj
  let l:url_arg = has("win32") ? l:url_raw : '"' . l:url_raw . '"'
  silent exe '!' . g:util_def_start l:url_arg
  redraw
endfunction

"" LaTeX recipes
function! s:util_latex_xelatex()
  let l:name = expand('%:r')
  exe '!xelatex -synctex=1 -interaction=nonstopmode -file-line-error' l:name . '.tex'
endfunction

function! s:util_latex_xelatex2()
  call s:util_latex_xelatex()
  call s:util_latex_xelatex()
endfunction

function! s:util_latex_biber()
  let l:name = expand('%:r')
  call s:util_latex_xelatex()
  exe '!biber' l:name . '.bcf'
  call s:util_latex_xelatex()
  call s:util_latex_xelatex()
endfunction

"" Git push all
function! s:util_git_push_all(...)
  let l:arg_list = a:000
  let l:git_root = Lib_Get_Git_Root()

  if l:git_root[0] == 1
    let l:git_branch = Lib_Get_Git_Branch(l:git_root)
  else
    echom "Not a git repository."
    return
  endif

  if l:git_branch[0] == 1
    echo "Root directory:" l:git_root[1]
    echo "Current branch:" l:git_branch[1]
    exe 'cd' l:git_root[1]
  else
    echom "Not a valid git repository."
    return
  endif

  if len(l:arg_list) % 2 == 0
    let l:m_index = index(l:arg_list, "-m")
    let l:b_index = index(l:arg_list, "-b")

    if (l:m_index >= 0) && (l:m_index % 2 == 0)
      let l:m_arg = l:arg_list[l:m_index + 1]
    elseif l:m_index < 0
      let l:time = strftime('%y%m%d')
      let l:m_arg = l:time
    else
      echom "Invalid commit argument."
      return
    endif
    silent exe '!git add *'
    silent exe '!git commit -m' l:m_arg
    echom "Commit message:" l:m_arg

    if (l:b_index >= 0) && (l:b_index % 2 == 0)
      let l:b_arg = l:arg_list[l:b_index + 1]
    elseif l:b_index < 0
      let l:b_arg = l:git_branch[1]
    else
      echom "Invalid branch argument."
    endif
    exe '!git push origin' l:b_arg
  else
    echom "Wrong number of arguments is given."
  endif
endfunction

"" Run code
function! s:util_run_or_compile(option)
  let l:optn = a:option
  let l:size = 30
  let l:cmdh = 'term'
  let l:file = expand('%:t')
  let l:name = expand('%:r')
  let l:exts = expand('%:e')
  if has("win32")
    let l:exec = ''
    let l:oute = '.exe'
  else
    let l:exec = './'
    let l:oute = ''
  end

  if l:exts ==? 'py'
    " PYTHON
    call Lib_Belowright_Split(l:size)
    exe l:cmdh 'python' l:file
  elseif l:exts ==? 'c'
    " C
    let l:cmd_arg = ['', 'check', 'build']
    if index(l:cmd_arg, l:optn) < 0
      echo "Invalid argument."
      return
    endif
    call Lib_Belowright_Split(l:size)
    if l:optn ==? ''
      exe l:cmdh g:util_def_cc l:file '-o' l:name . l:oute '&&' l:exec . l:name
    elseif l:optn ==? 'check'
      exe l:cmdh g:util_def_cc l:file '-g -o' l:name . l:oute
    elseif l:optn ==? 'build'
      exe l:cmdh g:util_def_cc l:file '-O2 -o' l:name . l:oute
    endif
  elseif l:exts ==? 'cpp'
    " C++
    call Lib_Belowright_Split(l:size)
    exe l:cmdh 'g++' l:file
  elseif l:exts ==? 'rs'
    " RUST
    let l:cmd_arg = ['', 'rustc', 'clean', 'check', 'build']
    if index(l:cmd_arg, l:optn) < 0
      echo "Invalid argument."
      return
    endif
    if l:optn ==? 'clean'
      exe '!cargo clean'
      return
    endif
    call Lib_Belowright_Split(l:size)
    if l:optn ==? ''
      exe l:cmdh 'cargo run'
    elseif l:optn ==? 'rustc'
      exe l:cmdh 'rustc' l:file '&&' l:exec . l:name
    elseif l:optn ==? 'check'
      exe l:cmdh 'cargo check'
    elseif l:optn ==? 'build'
      exe l:cmdh 'cargo build --release'
    endif
  elseif l:exts ==? 'vim'
    " VIML
    exe 'source %'
  elseif l:exts ==? 'lua'
    " LUA
    exe 'luafile %'
  else
    " ERROR
    echo 'Unknown file type: .' . l:exts
  endif
endfunction

"" Markdown number bullet
function! s:util_md_check_line(lnum)
  let l:lstr = getline(a:lnum)
  let l:detect = 0
  let l:bullet = 0
  let l:indent = strlen(matchstr(l:lstr, '\v^(\s*)')) 
  if l:lstr =~ '\v^\s*(\+|-|*)\s+.*$'
    let l:detect = 1
    let l:bullet = substitute(l:lstr,
          \ '\v^\s*(.)\s+.*$', '\=submatch(1)', '')
  elseif l:lstr =~ '\v^\s*(\d+)\.\s+.*$'
    let l:detect = 2
    let l:bullet = substitute(l:lstr,
          \ '\v^\s*(\d+)\.\s+.*$', '\=submatch(1)', '')
  endif
  return [l:detect, l:lstr, l:bullet, l:indent]
endfunction

function! s:util_md_insert_bullet()
  let l:lnum = line('.')
  let l:linf_c = s:util_md_check_line('.')

  let l:detect = 0
  let l:bullet = 0
  let l:indent = 0

  if l:linf_c[0] == 0
    let l:lnum_b = l:lnum - 1
    while l:lnum_b > 0
      let l:linf_b = s:util_md_check_line(l:lnum_b)
      if l:linf_b[3] < l:linf_c[3] && l:linf_b[0] != 0
        let l:detect = l:linf_b[0]
        let l:bullet = l:linf_b[2]
        let l:indent = l:linf_b[3]
        break
      endif
      let l:lnum_b -= 1
    endwhile
  else
    let l:detect = l:linf_c[0]
    let l:bullet = l:linf_c[2]
    let l:indent = l:linf_c[3]
  endif

  if l:detect == 0
    call feedkeys("\<C-o>o")
  else
    let l:lnum_f = l:lnum + 1
    let l:move_d = 0
    let l:move_record = []
    while l:lnum_f <= line('$')
      let l:linf_f = s:util_md_check_line(l:lnum_f)
      if l:linf_f[0] == l:detect && l:linf_f[3] == l:indent
        call add(l:move_record, l:move_d)
        if l:detect == 1
          break
        elseif l:detect == 2 && l:linf_f[0] == 2
          call setline(l:lnum_f, substitute(l:linf_f[1],
                \ '\v(\d+)', '\=submatch(1) + 1', ''))
        endif
      elseif l:linf_f[3] <= l:indent
        call add(l:move_record, l:move_d)
        break
      elseif l:lnum_f == line('$')
        call add(l:move_record, l:move_d + 1)
        break
      endif
      let l:lnum_f += 1
      let l:move_d += 1
    endwhile
    let l:count_d = len(l:move_record) == 0 ? 0 : l:move_record[0]
    let l:nbullet = l:detect == 2 ? (l:bullet + 1) . '. ' : l:bullet . ' '
    call feedkeys(repeat("\<C-g>U\<Down>", l:count_d) . "\<C-o>o\<C-o>0" .
          \ repeat("\<space>", l:indent) . l:nbullet)
  endif
endfunction

function s:util_md_sort_num_bullet()
  let l:lnum = line('.')
  let l:linf_c = s:util_md_check_line('.')

  if l:linf_c[0] == 2
    let l:num_lb = [l:lnum]
    let l:num_lf = []

    let l:lnum_b = l:lnum - 1
    while l:lnum_b > 0
      let l:linf_b = s:util_md_check_line(l:lnum_b)
      if l:linf_b[0] == 2
        if l:linf_b[3] == l:linf_c[3]
          call add(l:num_lb, l:lnum_b)
        elseif l:linf_b[3] < l:linf_c[3]
          break
        endif
      elseif l:linf_b[0] != 2 && l:linf_b[3] <= l:linf_c[3]
        break
      endif
      let l:lnum_b -= 1
    endwhile

    let l:lnum_f = l:lnum + 1
    while l:lnum_f <= line('$')
      let l:linf_f = s:util_md_check_line(l:lnum_f)
      if l:linf_f[0] == 2
        if l:linf_f[3] == l:linf_c[3]
          call add(l:num_lf, l:lnum_f)
        elseif l:linf_f[3] < l:linf_c[3]
          break
        endif
      elseif l:linf_f[0] != 2 && l:linf_f[3] <= l:linf_c[3]
        break
      endif
      let l:lnum_f += 1
    endwhile

    let l:num_la = reverse(l:num_lb) + l:num_lf

    let l:i = 1
    for item in l:num_la
      call setline(item, substitute(getline(item),
            \ '\v(\d+)', '\=' . l:i, ''))
      let l:i += 1
    endfor
  else
    echo "Not in a line of any numbered lists."
    return
  endif
endfunction

"" Calculate the day of week from a date(yyyy-mm-dd).
function! s:util_zeller(str)
  if a:str =~ '\v^.*\d{4}-\d{2}-\d{2}.*$' 
    let l:str_date = substitute(a:str,
          \ '\v^.*(\d{4}-\d{2}-\d{2}).*$',
          \ '\=submatch(1)', '')
    let l:str_to_list = split(l:str_date, '-')
    let l:a = l:str_to_list[0]
    let l:m = l:str_to_list[1]
    let l:d = l:str_to_list[2]
  else
    echom 'Not a valid date expression.'
    return ['']
  endif

  if l:m < 1 || l:m > 12
    echom 'Not a valid month.'
    return ['']
  endif

  if l:m == 2
    let l:month_days_count = 28
    if (l:a % 100 != 0 && l:a % 4 == 0) ||
     \ (l:a % 100 == 0 && l:a % 400 == 0)
      let l:month_days_count += 1
    endif
  else
    let l:month_days_count = 30
    if (l:m <= 7 && l:m % 2 == 1) ||
     \ (l:m >= 8 && l:m % 2 == 0)
      let l:month_days_count += 1
    endif
  endif

  if l:d < 1 || l:d > l:month_days_count
    echom 'Not a valid date.'
    return ['']
  endif

  if m == 1 || m == 2
    let l:a -= 1
    let l:m += 12
  endif

  let l:c = l:a / 100
  let l:y = l:a - l:c * 100
  let l:x = (c / 4) + y + (y / 4) + 26 * (m + 1) / 10 + d - 2 * c - 1
  let l:z = l:x % 7
  if l:z < 0 | let l:z += 7 | end
  let l:util_days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  return [l:util_days[l:z], l:str_date]
endfunction

function! s:util_append_day_from_date()
  let l:line = getline('.')
  let l:str = expand("<cWORD>")
  if l:str =~ '^$' | return | endif
  let l:cursor_pos = col('.')
  let l:match_start = 0
  while 1
    let l:match_cword = matchstrpos(l:line, l:str, l:match_start)[1:]
    if l:match_cword[0] <= l:cursor_pos &&
     \ l:match_cword[1] >= l:cursor_pos
      break
    endif
    let l:match_start = l:match_cword[1]
  endwhile
  let l:stt = l:match_cword[0]

  let l:day = s:util_zeller(l:str)
  if l:day[0] !=? ''
    let l:end = matchstrpos(l:line, l:day[1], l:stt)[2]
    call setpos('.', [0, line('.'), l:end])
    silent exe "normal! a " . l:day[0]
  endif
endfunction


" Key maps
"" Mouse toggle
nn  <silent> <F2> :call           <SID>util_mouse_toggle()<CR>
vn  <silent> <F2> :<C-u>call      <SID>util_mouse_toggle()<CR>
ino <silent> <F2> <C-o>:call      <SID>util_mouse_toggle()<CR>
tno <silent> <F2> <C-\><C-n>:call <SID>util_mouse_toggle()<CR>a
"" Background toggle
nn  <silent> <F5> :call           <SID>util_bg_toggle()<CR>
ino <silent> <F5> <C-o>:call      <SID>util_bg_toggle()<CR>
"" Terminal
nn  <M-t>      :call <SID>util_terminal()<CR>i
ino <M-t> <Esc>:call <SID>util_terminal()<CR>i
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
""" Explorer
nn  <silent> <F4>      :call <SID>util_explorer()<CR>
ino <silent> <F4> <Esc>:call <SID>util_explorer()<CR>
"" Hanzi count; <leader>wc -> w(ord)c(ount)
nn  <silent> <leader>wc
      \ :echo 'Chinese characters count: ' . <SID>util_hanzi_count("n")<CR>
vn  <silent> <leader>wc
      \ :<C-u>echo 'Chinese characters count: ' . <SID>util_hanzi_count("v")<CR>
"" Surround
nn <leader>ea :SurAddN<SPACE>
vn <leader>ea :<C-u>SurAddV<SPACE>
nn <leader>ed :SurDel<SPACE>
"" Search visual selection
vn  <silent> * y/\V<C-r>=Lib_Get_Visual_Selection()<CR><CR>
"" Search cword in web browser; <leader>f* -> f(ind)
for key in keys(s:util_web_list)
  exe 'nn <silent> <leader>f' . key ':call <SID>util_search_web("n", "' . key . '")<CR>'
  exe 'vn <silent> <leader>f' . key ':<C-u>call <SID>util_search_web("v", "' . key . '")<CR>'
endfor
"" List bullets
ino <silent> <M-CR> <C-o>:call <SID>util_md_insert_bullet()<CR>
nn  <silent> <leader>sl  :call <SID>util_md_sort_num_bullet()<CR>
"" Echo git status: <leader>v* -> v(ersion control)
nn <silent> <leader>vs :!git status<CR>
"" Append day of week after the date
nn <silent> <C-c><C-d> :call <SID>util_append_day_from_date()<CR>
"" Insert an orgmode-style timestamp at the end of the line
nn <silent> <C-c><C-c> A<C-R>=strftime(' <%Y-%m-%d %a %H:%M>')<CR><Esc>
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
ino <silent><expr> <C-f> col('.') >= col('$') ? "\<C-o>+" : g:custom_r
ino <silent><expr> <C-b> col('.') == 1 ? "\<C-o>-\<C-o>$" : g:custom_l


" Commands
"" Latex
command! Xe1 call <SID>util_latex_xelatex()
command! Xe2 call <SID>util_latex_xelatex2()
command! Bib call <SID>util_latex_biber()
"" Git
command! -nargs=* PushAll :call <SID>util_git_push_all(<f-args>)
"" Run code
command! -nargs=? CodeRun :call <SID>util_run_or_compile(<q-args>)
"" Echo time(May be useful in full screen?)
command! Time :echo strftime('%Y-%m-%d %a %T')
"" View PDF
command! -nargs=? -complete=file PDF :call <SID>util_pdf_view(<f-args>)
"" Surround
command! -nargs=1 SurAddN :call <SID>util_sur_add('n', <f-args>)
command! -nargs=1 SurAddV :call <SID>util_sur_add('v', <f-args>)
command! -nargs=1 SurDel  :call <SID>util_sur_del(<f-args>)
