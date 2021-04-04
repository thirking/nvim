-- Echo time(May be useful in full screen?)
vim.cmd('command! Time :echo strftime("%Y-%m-%d %a %T")')
-- LaTeX
vim.cmd('command! PDF lua require("utility/util").open_file(vim.fn.expand("%:p:r")..".pdf")')
-- Run or compile
vim.cmd('command! -nargs=? -complete=customlist,v:lua.RUN_CODE_OPTION CodeRun lua require("utility/util").run_or_compile(<q-args>)')
-- Git push all
vim.cmd('command! -nargs=* PushAll lua require("utility/vcs").git_push_all(<f-args>)')
-- Scroll off
require("utility/misc").set_au_group(
'scroll_off',
'BufEnter * setlocal so=5',
'BufEnter *.md setlocal so=999'
)

-- Neovim nightly upgrade
vim.cmd('command! -nargs=* NightlyUpgrade lua require("utility/util").nvim_nightly_upgrade(<f-args>)')

-- Run code complete option list.
function RUN_CODE_OPTION()
    local ft = vim.bo.filetype
    if ft == 'c' then
        return {'build', 'check'}
    elseif ft == 'rust' then
        return {'build', 'clean', 'check', 'rustc'}
    elseif ft == 'tex' then
        return {'biber', 'bibtex'}
    else
        return {''}
    end
end
