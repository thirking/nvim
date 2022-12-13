local packer_bootstrap = nil
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
    if vim.fn.executable("git") > 0 then
        packer_bootstrap = vim.fn.system {
            "git",
            "clone",
            "--depth", "1",
            "https://github.com/wbthomason/packer.nvim",
            packer_path
        }
        vim.cmd.packadd("packer.nvim")
    else
        vim.notify("Executable git is not found.", vim.log.levels.WARN, nil)
        return
    end
end

require("packer").startup(function(use)
    -- Package manager
    use "wbthomason/packer.nvim"
    -- Display
    use {
        { "goolord/alpha-nvim", opt = true };
        { "nvim-lualine/lualine.nvim", opt = true };
        { "akinsho/bufferline.nvim", opt = true };
        { "norcalli/nvim-colorizer.lua", opt = true };
        { "lukas-reineke/indent-blankline.nvim", opt = true };
    }
    -- Color scheme
    use {
        { "navarasu/onedark.nvim", opt = true };
        { "folke/tokyonight.nvim", opt = true };
        { "ellisonleao/gruvbox.nvim", opt = true };
        { "EdenEast/nightfox.nvim", opt = true };
        { "rmehri01/onenord.nvim", opt = true };
    }
    -- File system
    use {
        {
            "nvim-tree/nvim-tree.lua",
            config = function() require("packages.nvim-tree") end
        };
        {
            "nvim-telescope/telescope.nvim",
            config = function() require("packages.telescope") end
        };
    }
    -- VCS
    use {
        {
            "TimUntersberger/neogit",
            commit = "05386ff1e9da447d4688525d64f7611c863f05ca",
            config = function() require("packages.neogit") end
        };
        {
            "sindrets/diffview.nvim",
            config = function() require("packages.diffview") end
        };
        {
            "lewis6991/gitsigns.nvim",
            config = function() require("packages.gitsigns") end
        };
    }
    -- Utilities
    use {
        "nvim-lua/plenary.nvim";
        "tpope/vim-speeddating";
        {
            "dhruvasagar/vim-table-mode",
            config = function() require("packages.vim-table-mode") end
        };
        {
            "AnthonyK213/lua-pairs",
            config = function() require("packages.lua-pairs") end
        };
        {
            "andymass/vim-matchup"
        };
        {
            "Shatur/neovim-session-manager",
            config = function() require("packages.neovim-session-manager") end
        };
        {
            "stevearc/dressing.nvim",
            config = function() require("packages.dressing") end
        };
        {
            "akinsho/toggleterm.nvim",
            tag = "*",
            config = function() require("packages.toggleterm") end
        };
        {
            "saecki/crates.nvim",
            tag = "v0.3.0",
            config = function() require("packages.crates") end
        };
    }
    -- File type support
    use {
        {
            "lervag/vimtex",
            config = function() require("packages.vimtex") end
        };
        {
            "vimwiki/vimwiki",
            branch = "dev",
            config = function() require("packages.vimwiki") end
        };
        {
            "iamcco/markdown-preview.nvim",
            run = function() vim.fn["mkdp#util#install"]() end,
            config = function() require("packages.markdown-preview") end
        };
        "sotte/presenting.vim";
        "gpanders/editorconfig.nvim";
    }
    -- Completion; Snippet; LSP; Treesitter; DAP
    use {
        {
            "hrsh7th/nvim-cmp",
            requires = {
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-nvim-lsp-signature-help",
                "hrsh7th/cmp-omni",
                "hrsh7th/cmp-path",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            },
            config = function() require("packages.nvim-cmp") end
        };
        {
            "neovim/nvim-lspconfig",
            config = function() require("packages.nvim-lspconfig") end,
            requires = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
            }
        };
        {
            "nvim-treesitter/nvim-treesitter",
            config = function() require("packages.nvim-treesitter") end
        };
        {
            "stevearc/aerial.nvim",
            config = function() require("packages.aerial") end
        };
        {
            "mfussenegger/nvim-dap",
            config = function() require("packages.nvim-dap") end
        };
    }
    -- Games
    use {
        "alec-gibson/nvim-tetris",
        "AndrewRadev/gnugo.vim"
    }
    -- Documentation
    use {
        "nanotee/luv-vimdocs",
    }

    if packer_bootstrap then
        require("packer").sync()
        require("utility.util").build_dylibs()
    end
end)

-- Built-in plugins.
if _my_core_opt.plug then
    if not _my_core_opt.plug.matchit then vim.g.loaded_matchit = 1 end
    if not _my_core_opt.plug.matchparen then vim.g.loaded_matchparen = 1 end
end

-- Optional packages.
local colorscheme_list = { "onedark", "tokyonight", "gruvbox", "nightfox", "onenord" }
local colorscheme = _my_core_opt.tui.scheme
vim.o.tgc = true
vim.o.bg = _my_core_opt.tui.theme or "dark"
vim.g._my_theme_switchable = false
local nvim_init_src = vim.g.nvim_init_src or vim.env.NVIM_INIT_SRC
if nvim_init_src == "nano" then
    vim.g._my_theme_switchable = true
    vim.cmd.colorscheme("nanovim")
elseif packer_bootstrap == nil then
    -- Load color scheme.
    if vim.tbl_contains(colorscheme_list, colorscheme) then
        require("packages." .. colorscheme)
    else
        if not pcall(vim.cmd.colorscheme, colorscheme) then
            vim.notify("Color scheme was not found.", vim.log.levels.WARN, nil)
        end
    end
    if nvim_init_src ~= "neatUI" then
        require("packages.alpha-nvim")
        require("packages.bufferline")
        require("packages.lualine")
        require("packages.nvim-colorizer")
        require("packages.indent-blankline")
    end
end
