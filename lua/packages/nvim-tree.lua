vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 0
}
vim.g.nvim_tree_icons = {
    default = '▪ ',
    symlink = '▫ ',
    git = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "U",
        renamed = "➜",
        untracked = "★",
        deleted = "D",
        ignored = "◌"
    },
    folder = {
        default = "+",
        open = "-",
        empty = "*",
        empty_open = "*",
        symlink = "@",
        symlink_open = "@",
    }
}

require('nvim-tree').setup {
    disable_netrw = true,
    hijack_cursor = true,
    view = {
        mappings = {
            custom_only = true,
            list = {
                { key = {"<CR>", "<2-LeftMouse>"}, action = "edit" },
                { key = {"C", "<2-RightMouse>"},   action = "cd" },
                { key = "<C-I>",  action = "toggle_ignored" },
                { key = "<C-J>",  action = "next_sibling" },
                { key = "<C-K>",  action = "prev_sibling" },
                { key = "<C-R>",  action = "full_rename" },
                { key = "<M-Y>",  action = "copy_absolute_path" },
                { key = "<M-y>",  action = "copy_path" },
                { key = "<S-CR>", action = "close_node" },
                { key = "<Tab>",  action = "preview" },
                { key = "D",      action = "remove" },
                { key = "H",      action = "toggle_dotfiles" },
                { key = "R",      action = "refresh" },
                { key = "a",      action = "create" },
                { key = "c",      action = "copy" },
                { key = "gj",     action = "next_git_item" },
                { key = "gk",     action = "prev_git_item" },
                { key = "i",      action = "split" },
                { key = "o",      action = "system_open" },
                { key = "p",      action = "paste" },
                { key = "q",      action = "close" },
                { key = "r",      action = "rename" },
                { key = "s",      action = "vsplit" },
                { key = "t",      action = "tabnew" },
                { key = "u",      action = "dir_up" },
                { key = "x",      action = "cut" },
                { key = "y",      action = "copy_name" },
            }
        }
    },
    diagnostics = {
        enable = true,
        show_on_dirs = false,
        icons = {
            hint = "!",
            info = "I",
            warning = "W",
            error = "E"
        }
    },
    filters = {
        dotfiles = true,
        custom = { '.git', '.cache' }
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 400
    },
    actions = {
        change_dir = {
            enable = false,
            global = false,
        },
        open_file = {
            quit_on_open = false,
            resize_window = false,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = {
                        "notify", "qf", "help",
                        "packer", "aerial"
                    },
                    buftype = {
                        "terminal"
                    }
                }
            }
        }
    }
}


local kbd = vim.keymap.set
local ntst = { noremap = true, silent = true }
kbd('n', '<leader>op', ':NvimTreeToggle<CR>',        ntst)
kbd('n', '<M-e>',      ':NvimTreeFindFile<CR>',      ntst)
kbd('i', '<M-e>',      '<ESC>:NvimTreeFindFile<CR>', ntst)
