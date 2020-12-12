" Load plug-ins
call plug#begin(stdpath('data') . '/plugged')
    " Visual
    Plug 'joshdick/onedark.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'Yggdroot/indentLine'
    " Tree manager
    Plug 'preservim/nerdtree'
    " Git utilities
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tpope/vim-fugitive'
    Plug 'mhinz/vim-signify'
    " Completion; LSP
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " File type support
    Plug 'lervag/vimtex'
    Plug 'sophacles/vim-processing'
    Plug 'plasticboy/vim-markdown'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
    Plug 'jceb/vim-orgmode'
    " Utilities
    Plug 'tpope/vim-speeddating'
    Plug 'dhruvasagar/vim-table-mode'
call plug#end()
