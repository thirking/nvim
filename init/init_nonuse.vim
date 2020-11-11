Plug 'rakr/vim-one'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'

"" deoplete
let g:deoplete#enable_at_startup=1
set completeopt-=preview


set relativenumber
set foldenable
set foldmethod=syntax
set foldlevelstart=99
set foldmethod=manual
set clipboard=unnamed

set whichwrap=b,s,<,>,[,]
set backspace=indent,eol,start whichwrap+=<,>,[,]
set textwidth=0
set wrapmargin=0
set formatoptions-=tc
set formatoptions+=l
set signcolumn=number

highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

augroup remember_folds
    autocmd!
    au BufWinLeave ?* mkview 1
    au BufWinEnter ?* silent! loadview 1
augroup end


" Pairs
let g:usr_pairs = ["()", "[]", "{}", "\"\"", "''", "``", "**", "<>"]
let g:usr_quote = ["\"", "'"]

function! IsEncompByPair(pair_list)
    return index(a:pair_list, Lib_Get_Char(0) . Lib_Get_Char(1))
endfunction

function! PairEnter()
    return IsEncompByPair(g:usr_pairs) >= 0 ? "\<CR>\<ESC>O" : "\<CR>"
endfunction

function! PairBacks()
    return IsEncompByPair(g:usr_pairs) >= 0 ? "\<C-G>U\<Right>\<BS>\<BS>" : "\<BS>"
endfunction

function! PairMates(pair_a, pair_b)
    return Lib_Is_Word(Lib_Get_Char(1)) ? a:pair_a : a:pair_a . a:pair_b . "\<C-G>U\<Left>"
endfunction

function! PairClose(pair_b)
    return Lib_Get_Char(1) ==# a:pair_b ? "\<C-G>U\<Right>" : a:pair_b
endfunction

function! PairQuote(quote)
    let last_char = Lib_Get_Char(0)
    let next_char = Lib_Get_Char(1)
    let l_is_word = Lib_Is_Word(last_char)
    let n_is_word = Lib_Is_Word(next_char)
    if next_char ==# a:quote && (last_char ==# a:quote || l_is_word)
        return "\<C-G>U\<Right>"
    elseif l_is_word || n_is_word || index(g:usr_quote + g:last_spec, last_char) >= 0 || index(g:usr_quote + g:next_spec, next_char) >= 0
        return a:quote
    else
        return a:quote . a:quote . "\<C-G>U\<Left>"
    endif
endfunction

inoremap <silent>  (   <C-r>=PairMates("(", ")")<CR>
inoremap <silent>  [   <C-r>=PairMates("[", "]")<CR>
inoremap <silent>  {   <C-r>=PairMates("{", "}")<CR>
inoremap <silent>  )   <C-r>=PairClose(")")<CR>
inoremap <silent>  ]   <C-r>=PairClose("]")<CR>
inoremap <silent>  }   <C-r>=PairClose("}")<CR>
inoremap <silent>  '   <C-r>=PairQuote("'")<CR>
inoremap <silent>  "   <C-r>=PairQuote("\"")<CR>
" <CR> could be remapped by other plugin.
inoremap <silent> <CR> <C-r>=PairEnter()<CR>
inoremap <silent> <BS> <C-r>=PairBacks()<CR>

" markdown
inoremap <expr> <M-p> "``\<C-G>U\<Left>"
inoremap <expr> <M-i> "**\<C-G>U\<Left>"
inoremap <expr> <M-b> "****"   . repeat("\<C-G>U\<Left>", 2)
inoremap <expr> <M-m> "******" . repeat("\<C-G>U\<Left>", 3)
