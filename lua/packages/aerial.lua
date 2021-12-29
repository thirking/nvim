local aerial = require'aerial'
require('telescope').load_extension('aerial')

vim.g.aerial = {
    backends = { "lsp", "treesitter", "markdown" },
    manage_folds = false,
}

aerial.register_attach_cb(function(bufnr)
    -- Toggle the aerial window with <leader>a
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>mv', '<Cmd>AerialToggle!<CR>', {})
    -- Jump forwards/backwards with '{' and '}'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<Cmd>AerialPrev<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<Cmd>AerialNext<CR>', {})
    -- Jump up the tree with '[[' or ']]'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<Cmd>AerialPrevUp<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<Cmd>AerialNextUp<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fa', '<Cmd>Telescope aerial<CR>', {})
end)
