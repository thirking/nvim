" Create a below right split window.
function! Lib_Belowright_Split(height)
    let height = min([a:height, nvim_win_get_height(0) / 2])
    belowright split
    exe 'resize ' . height
endfunction


" Find the root directory of .git
function! Lib_Get_Git_Root()
    let dir = expand('%:p:h')
    while 1
        if !empty(globpath(dir, ".git", 1)) | return [1, dir] | endif
        let [current, dir] = [dir, fnamemodify(dir, ':h')]
        if current == dir | break | endif
    endwhile
    return [0, '']
endfunction


" Get the character around the cursor.
function! Lib_Get_Char(num) abort
    return matchstr(getline('.'), '\%' . (col('.') + a:num - 1) . 'c.')
endfunction


" Determines whether a character is a letter or a symbol.
function! Lib_Is_Word(char)
    let code = char2nr(a:char)
    if code > 128
        return 0
    elseif code >= 48 && code <= 57
        return 1
    elseif code >= 65 && code <= 90
        return 1
    elseif code >= 97 && code <= 122
        return 1
    else
        return 0
    endif
endfunction


" Determines if a character is a Chinese character.
function! Lib_Is_Hanzi(char)
    let code = char2nr(a:char)
    if code >= 0x4E00 && code <= 0x9FA5
        return 1
    else
        return 0
    endif
endfunction


" Return the <cWORD> without the noisy characters.
function! Lib_Get_Clean_CWORD(del_list)
    let c_word = expand("<cWORD>")
    while index(a:del_list, c_word[(len(c_word) - 1)]) >= 0 && len(c_word) >= 2
        let c_word = c_word[:(len(c_word) - 2)]
    endwhile
    while index(a:del_list, c_word[0]) >= 0 && len(c_word) >= 2
        let c_word = c_word[1:]
    endwhile
    return c_word
endfunction


" Return the selections as string.
function! Lib_Get_Visual_Selection()
    try
        let a_save = @a
        silent normal! gv"ay
        return @a
    finally
        let @a = a_save
    endtry
endfunction


" Replace chars in a string according to a dictionary.
function! Lib_Str_Escape(str, esc_dict)
    let str_lst = split(a:str, '.\zs')
    let i = 0
    for char in str_lst
        if has_key(a:esc_dict, char)
            let str_lst[i] = a:esc_dict[char]
        endif
        let i = i + 1
    endfor
    return join(str_lst, '')
endfunction