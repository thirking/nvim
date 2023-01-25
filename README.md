# Neovim Configuration


## Requirements
* [**Neovim**](https://github.com/neovim/neovim) 0.8+
* [**Git**](https://github.com/git/git)
* [**ripgrep**](https://github.com/BurntSushi/ripgrep)
  & [**fd**](https://github.com/sharkdp/fd)


## Installation
* **Clone repository**
  - Windows
    ```ps1
    git clone --depth=1 https://github.com/AnthonyK213/nvim.git `
                        "$env:LOCALAPPDATA\nvim"
    ```
  - GNU/Linux
    ```sh
    git clone --depth=1 https://github.com/AnthonyK213/nvim.git \
                        "${XDG_DATA_HOME:-$HOME/.config}"/nvim
    ```
* **Start Neovim and wait for the installation to complete**
* **Customize with `nvimrc`**
  - In the `home`|`config` directory, names `.nvimrc`
    (also can be `_nvimrc` on Windows)
  - Example
    ``` json
    {
      // Dependencies
      "dep": {
        // (string|array) Shell
        "sh": ["pwsh", "-nologo"],
        // (string) C compiler
        "cc": "clang",
        // (string) Python3 executable path
        "py3": "python3/executable/path",
        // (string) Proxy
        "proxy": "http://127.0.0.1:7890"
      },
      // Paths
      "path": {
        // (string) Home directory
        "home": "$HOME",
        // (string) Cloud drive directory
        "cloud": "$HOME/cloud",
        // (string) Desktop directory
        "desktop": "$HOME/Desktop",
        // (string) Binaries directory
        "bin": "$HOME/bin"
      },
      // Terminal UI
      "tui": {
        // ("onedark"|"tokyonight"|"gruvbox"|"nightfox"|"onenord") Color scheme
        "scheme": "nightfox",
        // ("dark"|"light") Tui background theme
        "theme": "dark",
        // (string) Style of color scheme
        "style": "nord",
        // (boolean) Make background transparent
        "transparent": false,
        // (boolean) Global statusline
        "global_statusline": false,
        // (string) Floating window border style
        "border": "single",
        // (boolean) nvim-cmp ghost text
        "cmp_ghost": false,
        // (boolean) Dim inactive window automatically
        "auto_dim": false
      },
      // GUI (neovim-qt, fvim)
      "gui": {
        // ("auto"|"dark"|"light") GUI background theme
        "theme": "auto",
        // (number) Window opacity
        "opacity": 0.98,
        // (boolean) Render ligatures
        "ligature": false,
        // (boolean) Use GUI popup menu
        "popup_menu": false,
        // (boolean) Use GUI tabline
        "tabline": false,
        // (boolean) Use GUI scroll bar
        "scroll_bar": false,
        // (number) Line space
        "line_space": 0.0,
        // (number) GUI font size
        "font_size": 13,
        // (string) See `guifont`
        "font_half": "Monospace",
        // (string) See `guifontwide`
        "font_full": "Monospace"
      },
      // Language Server Protocol
      "lsp": {
        // (boolean|object) https://github.com/clangd/clangd
        "clangd": true,
        // (boolean|object) https://github.com/OmniSharp/omnisharp-roslyn
        "omnisharp": {
          "load": true,
          // Some LSPs' semantic tokens are not usable
          "disable_semantic_tokens": true
        },
        // (boolean|object) https://github.com/microsoft/pyright
        "pyright": {
          "load": true,
          // Extra settings, depends on the LSP
          "settings": {
            "python": {
              "analysis": {
                "autoSearchPaths": true,
                "diagnosticMode": "workspace",
                "useLibraryCodeForTypes": true,
                "stubPath": "stubPath",
                "typeCheckingMode": "off"
              }
            }
          }
        },
        // (boolean|object) https://github.com/rust-analyzer/rust-analyzer
        "rust_analyzer": true,
        // (boolean|object) https://github.com/sumneko/lua-language-server
        "sumneko_lua": {
          "load": true,
          "settings": {
            "Lua": {
              "runtime": {
                "version": "LuaJIT"
              },
              "diagnostics": {
                "globals": [ "vim" ]
              },
              "workspace": {
                // "${lua_expression}" is allowed.
                "library": "${vim.api.nvim_get_runtime_file(\"\", true)}",
                "checkThirdParty": false
              },
              "telemetry": {
                "enable": false
              }
            }
          }
        },
        // (boolean|object) https://github.com/iamcco/vim-language-server
        "vimls": true
        // And so on...
      },
      // Treesitter
      "ts": {
        // (array) Parsers to install automatically
        "ensure": [],
        // (array) File type to disable treesitter highlight
        "hi_disable": []
      },
      // Debug Adapter Protocol
      "dap": {
        // (boolean) https://github.com/llvm/llvm-project
        "lldb": false,
        // (boolean) https://github.com/Samsung/netcoredbg
        "csharp": false,
        // (boolean) https://github.com/microsoft/debugpy
        "python": false
      },
      // Built-in plugins
      "plug": {
        // (boolean) Enable matchit.vim
        "matchit": false,
        // (boolean) Enable matchparen.vim
        "matchparen": false
      },
      // Version control system
      "vcs": {
        // ("neogit"|"lazygit") Git client
        "client": "neogit"
      }
    }
    ```
* **Install LSP servers via `mason.nvim`**
* **Set .vimrc for Vim (optional)**
  - Windows
    ```ps1
    Copy-Item "$env:LOCALAPPDATA\nvim\viml\vimrc.vim" `
              -Destination "$env:HOMEPATH\_vimrc"
    ```
  - GNU/Linux
    ```sh
    cp "${XDG_DATA_HOME:-$HOME/.config}"/nvim/viml/vimrc.vim \
       "${XDG_DATA_HOME:-$HOME}"/.vimrc
    ```
* **Set mailboxes (optional)**
  - In the `home`|`config` directory, names `.mail.json`
    (also can be `_mail.json` on Windows)
  - Example
    ``` json
    {
      "archive": "/path/to/email/archive/directory/",
      "providers": [
        {
          "label": "A unique label for the mailbox provider",
          "smtp": "SMTP server address",
          "imap": "IMAP server address",
          "port": 993,
          "user_name": "User name",
          "password": "Password"
        }
      ]
    }
    ```


## Key bindings
* **Ctrl**
  - in:  <kbd>C-S</kbd>  -> Save.
  - n:   <kbd>C-Dt</kbd> -> Adjust window size.
* **Meta**
  - in:  <kbd>M-a</kbd>  -> Select all.
  - v:   <kbd>M-c</kbd>  -> Copy to system clipboard.
  - t:   <kbd>M-d</kbd>  -> Close the terminal.
  - in:  <kbd>M-e</kbd>  -> *nvim-tree.lua*, nvim-tree find file.
  - nv:  <kbd>M-g</kbd>  -> Find and replace.
  - nv:  <kbd>M-h</kbd>  -> Jump to the window left.
  - nv:  <kbd>M-j</kbd>  -> Jump to the window below.
  - nv:  <kbd>M-k</kbd>  -> Jump to the window above.
  - nv:  <kbd>M-l</kbd>  -> Jump to the window right.
  - nv:  <kbd>M-n</kbd>  -> Move line(s) down.
  - nv:  <kbd>M-p</kbd>  -> Move line(s) up.
  - inv: <kbd>M-v</kbd>  -> Paste from system clipboard.
  - inv: <kbd>M-w</kbd>  -> Jump to the window in turns.
  - v:   <kbd>M-x</kbd>  -> Cut to system clipboard.
  - n:   <kbd>M-,</kbd>  -> Open `nvimrc`.
  - i:   <kbd>M-CR</kbd> -> Auto insert bullet.
  - in:  <kbd>M-Nr</kbd> -> Goto tab(Number: 1, 2, 3, ..., 9, 0).
  - in:  <kbd>M-B</kbd>  -> Markdown **bold**.
  - in:  <kbd>M-I</kbd>  -> Markdown *italic*.
  - in:  <kbd>M-M</kbd>  -> Markdown ***bold_italic***.
  - in:  <kbd>M-P</kbd>  -> Markdown `block`.
  - inv: <kbd>M-U</kbd>  -> Markdown/HTML <u>underscore</u>.
* **Emacs shit**
  - inv: <kbd>C-N</kbd>  -> Cursor down.
  - inv: <kbd>C-P</kbd>  -> Cursor up.
  - ci:  <kbd>C-B</kbd>  -> Cursor left.
  - ci:  <kbd>C-F</kbd>  -> Cursor right.
  - ci:  <kbd>C-A</kbd>  -> To the first character of the screen line.
  - ci:  <kbd>C-E</kbd>  -> To the last character of the screen line.
  - i:   <kbd>C-K</kbd>  -> Kill text until the end of the line.
  - cin: <kbd>M-b</kbd>  -> Cursor one word left.
  - cin: <kbd>M-f</kbd>  -> Cursor one word right.
  - i:   <kbd>M-d</kbd>  -> Kill text until the end of the word.
  - in:  <kbd>M-x</kbd>  -> Command-line mode.
* **Leader**
  > <kbd>leader</kbd> is mapped to <kbd>SPACE</kbd>.
  - <kbd>leader-b-</kbd> -> **Buffer**.
    - n:    <kbd>b</kbd> -> *nvim-bufferline.lua*, BufferLinePick.
    - n:    <kbd>c</kbd> -> Set directory to the current buffer.
    - n:    <kbd>d</kbd> -> Delete buffer.
    - n:    <kbd>g</kbd> -> Toggle background.
    - n:    <kbd>h</kbd> -> Stop the search highlighting.
    - n:    <kbd>n</kbd> -> Next buffer.
    - n:    <kbd>p</kbd> -> Previous buffer.
  - <kbd>leader-c-</kbd> -> **Check**.
    - nv:   <kbd>c</kbd> -> Chinese characters count.
    - n:    <kbd>s</kbd> -> Toggle spell check.
  - <kbd>leader-d-</kbd> -> **Debug**.
    - n:    <kbd>b</kbd> -> *nvim-dap*, toggle break point.
    - n:    <kbd>c</kbd> -> *nvim-dap*, clear break point.
    - n:    <kbd>l</kbd> -> *nvim-dap*, run last.
    - n:    <kbd>r</kbd> -> *nvim-dap*, toggle REPL window.
    - n:    <kbd>t</kbd> -> *nvim-dap*, terminate.
  - <kbd>leader-e-</kbd> -> **Evaluate**.
    - n:    <kbd>v</kbd> -> Evaluate lua chunk surrounded by backquote.
    - n:    <kbd>l</kbd> -> Evaluate lisp chunk(math) surrounded by backquote.
  - <kbd>leader-f-</kbd> -> **Find**.
    - n:    <kbd>b</kbd> -> *telescope.nvim*, buffers.
    - n:    <kbd>f</kbd> -> *telescope.nvim*, find_files.
    - n:    <kbd>g</kbd> -> *telescope.nvim*, live_grep.
  - <kbd>leader-g-</kbd> -> **VCS**.
    - n:    <kbd>b</kbd> -> *gitsigns.nvim*, blame line.
    - n:    <kbd>d</kbd> -> *diffview.nvim*, open diffview in tab.
    - n:    <kbd>h</kbd> -> *diffview.nvim*, open diffview file history in tab.
    - n:    <kbd>j</kbd> -> *gitsigns.nvim*, next hunk.
    - n:    <kbd>k</kbd> -> *gitsigns.nvim*, previous hunk.
    - n:    <kbd>n</kbd> -> *neogit*/*toggleterm.nvim*, open git client window.
    - n:    <kbd>p</kbd> -> *gitsigns.nvim*, preview hunk.
    - n:    <kbd>s</kbd> -> Git status.
  - <kbd>leader-h-</kbd> -> **Search text in web browser**.
    - nv:   <kbd>b</kbd> -> Search cword with Baidu.
    - nv:   <kbd>g</kbd> -> Search cword with Google.
    - nv:   <kbd>h</kbd> -> Search cword with Github.
    - nv:   <kbd>y</kbd> -> Search cword with Youdao.
  - <kbd>leader-k-</kbd> -> **Comment**.
    - nv:   <kbd>c</kbd> -> Comment current/selected line(s).
    - nv:   <kbd>u</kbd> -> Uncomment current/selected line(s).
  - <kbd>leader-l-</kbd> -> **LSP**
    - n:    <kbd>0</kbd> -> Document symbol.
    - n:    <kbd>a</kbd> -> Code action.
    - n:    <kbd>d</kbd> -> Jump to declaration.
    - n:    <kbd>f</kbd> -> Jump to definition.
    - n:    <kbd>h</kbd> -> Signature help.
    - n:    <kbd>i</kbd> -> Implementation.
    - n:    <kbd>k</kbd> -> Show diagnostics in a floating window.
    - n:    <kbd>m</kbd> -> Format.
    - n:    <kbd>n</kbd> -> Rename.
    - n:    <kbd>r</kbd> -> References.
    - n:    <kbd>t</kbd> -> Type definition.
    - n:    <kbd>w</kbd> -> Work space symbol.
    - n:    <kbd>[</kbd> -> Jump to previous diagnostic mark.
    - n:    <kbd>]</kbd> -> Jump to next diagnostic mark.
  - <kbd>leader-m-</kbd> -> **Markdown**, **Mail**
    - n:    <kbd>f</kbd> -> Fetch recently unseen mails from IMAP server.
    - n:    <kbd>l</kbd> -> Regenerate list bullets.
    - n:    <kbd>n</kbd> -> Create a new mail(.eml file).
    - n:    <kbd>s</kbd> -> Send current buffer as an e-mail.
    - n:    <kbd>v</kbd> -> *aerial.nvim*/*VimTeX*, Toc toggle.
    - n:    <kbd>t</kbd> -> *markdown-preview.nvim*, markdown preview toggle;
                            [marp](https://marp.app/) server toggle;
                            LaTeX project pdf preview.
  - <kbd>leader-n-</kbd> -> **GTD**.
    - n:    <kbd>d</kbd> -> Append the weekday after a date(yyyy-mm-dd).
    - n:    <kbd>s</kbd> -> Insert timestamp after cursor.
    - n:    <kbd>t</kbd> -> Print TODO list.
  - <kbd>leader-o-</kbd> -> **Open**.
    - n:    <kbd>b</kbd> -> Open file of buffer with system default browser.
    - n:    <kbd>e</kbd> -> Open system file manager.
    - n:    <kbd>t</kbd> -> Open terminal.
    - n:    <kbd>p</kbd> -> *nvim-tree.lua*, nvim-tree toggle.
    - n:    <kbd>u</kbd> -> Open path or url under the cursor.
  - <kbd>leader-s-</kbd> -> **Surrounding**.
    - nv:   <kbd>a</kbd> -> Surrounding add.
    - n:    <kbd>c</kbd> -> Surrounding change.
    - n:    <kbd>d</kbd> -> Surrounding delete.
  - <kbd>leader-t-</kbd> -> **Table mode**.
    - n:    <kbd>a</kbd> -> *vim-table-mode*, Add formula.
    - n:    <kbd>c</kbd> -> *vim-table-mode*, Evaluate formula.
    - n:    <kbd>f</kbd> -> *vim-table-mode*, Re-align.
  - <kbd>leader-v-</kbd> -> **Visual**
    - n:    <kbd>s</kbd> -> Show highlight information.
  - <kbd>leader-w-</kbd> -> **Vimwiki**.
  - <kbd>leader-z-</kbd> -> Misc.
    - v:   <kbd>bd</kbd> -> Base64 decode selection.
    - v:   <kbd>be</kbd> -> Base64 encode selection.
* **Miscellanea**
  - v:   <kbd>\*/#</kbd> -> Search for the visual selection.
  - invt:<kbd>F2</kbd>   -> Toggle mouse status.
  - n:   <kbd>F5</kbd>   -> *nvim-dap*, continue debugging.
  - n:   <kbd>F6</kbd>   -> *nvim-dap*, step over.
  - n:   <kbd>F7</kbd>   -> *nvim-dap*, step into.
  - n:   <kbd>F8</kbd>   -> *nvim-dap*, step out.
  - n:   <kbd>S-F5</kbd> -> `CodeRun`.
  - n:   <kbd>C-S-F5</kbd> -> `CodeRun test`.


## Commands
- `CodeRun`     -> Run or compile the code.
- `BuildDylibs` -> Build crates in `$config/rust/` directory.
- `NvimUpgrade` -> Upgrade neovim by channel input.
- `PushAll`     -> Just push everything to the remote origin.
  - `-b`        -> branch (default: current branch).
  - `-m`        -> commit (default: date).
  - `-r`        -> remote (default: origin).
- `SshConfig`   -> Open and edit ~/.ssh/config
- `Time`        -> Print date and time.


## Packages
* Package manager
  - [packer.nvim](https://github.com/wbthomason/packer.nvim)
* Display(Optional)
  - [alpha-nvim](https://github.com/goolord/alpha-nvim)
  - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
  - [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
  - [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)
  - [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
* Color scheme(Optional)
  - [onedark.nvim](https://github.com/navarasu/onedark.nvim)
  - [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
  - [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)
  - [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)
  - [onenord.nvim](https://github.com/rmehri01/onenord.nvim)
* File system
  - [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua)
  - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
* VCS
  - [diffview.nvim](https://github.com/sindrets/diffview.nvim)
  - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
  - [Neogit](https://github.com/TimUntersberger/neogit)
* Utilities
  - [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
  - [vim-speeddating](https://github.com/tpope/vim-speeddating)
  - [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
  - [lua-pairs](https://github.com/anthonyk213/lua-pairs)
  - [vim-matchup](https://github.com/andymass/vim-matchup)
  - [neovim-session-manager](https://github.com/Shatur/neovim-session-manager)
  - [dressing.nvim](https://github.com/stevearc/dressing.nvim)
  - [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
* File type support
  - [VimTeX](https://github.com/lervag/vimtex)
  - [vimwiki](https://github.com/vimwiki/vimwiki)
  - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
  - [presenting.vim](https://github.com/sotte/presenting.vim)
  - [editorconfig.nvim](https://github.com/gpanders/editorconfig.nvim)
  - [vim-fsharp](https://github.com/PhilT/vim-fsharp)
* Completion; Snippet; LSP; TreeSitter; DAP
  - [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
  - [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
  - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
  - [mason.nvim](https://github.com/williamboman/mason.nvim)
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  - [aerial.nvim](https://github.com/stevearc/aerial.nvim)
  - [nvim-dap](https://github.com/mfussenegger/nvim-dap)
* Games
  - [nvim-tetris](https://github.com/alec-gibson/nvim-tetris)
  - [gnugo.vim](https://github.com/AndrewRadev/gnugo.vim)
