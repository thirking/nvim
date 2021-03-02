-- Echo time(May be useful in full screen?)
vim.cmd('command! Time :echo strftime("%Y-%m-%d %a %T")')
-- LaTeX
vim.cmd('command! PDF lua require("utility/util").open_file(vim.fn.expand("%:r")..".pdf")')
-- Run or compile
vim.cmd('command! -nargs=? -complete=customlist,v:lua.RunCompOpt CodeRun lua require("utility/util").run_or_compile(<q-args>)')
-- Git push all
vim.cmd('command! -nargs=* PushAll lua require("utility/util").git_push_all(<f-args>)')
-- Scroll off
vim.cmd('augroup scroll_off')
vim.cmd('autocmd!')
vim.cmd('au BufEnter * setlocal so=5')
vim.cmd('au BufEnter *.md setlocal so=999')
vim.cmd('augroup end')


function RunCompOpt()
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
