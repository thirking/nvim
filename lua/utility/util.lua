local M = {}
local lib = require('utility/lib')
local pub = require('utility/pub')


-- Open terminal and launch shell.
function M.terminal()
    lib.belowright_split(15)
    vim.cmd('terminal '..pub.shell)
    vim.cmd('setl nonu')
end

-- Show documents.
function M.show_doc()
    if vim.tbl_contains({'vim', 'help'}, vim.bo.filetype) then
        local cword = vim.fn.expand('<cword>')
        local ok, err = pcall(function () vim.cmd('h '..cword) end)
        if not ok then
            msg = err:match('(E%d+:%s.+)$')
            if not msg then msg = 'No help for '..cword end
            vim.notify(msg, vim.log.levels.ERROR, nil)
        end
    else
        vim.lsp.buf.hover()
    end
end

-- Open and edit text file in vim.
function M.edit_file(file_path, chdir)
    local path = vim.fn.expand(file_path)
    if vim.fn.expand("%:t") == '' then
        vim.cmd('e '..path)
    else
        vim.cmd('tabnew '..path)
    end
    if chdir then
        vim.api.nvim_set_current_dir(vim.fn.expand('%:p:h'))
    end
end

-- Match path or url in string.
function M.match_path_or_url(str)
    local protocols = {
        [''] = 0,
        ['http://'] = 0,
        ['https://'] = 0,
        ['ftp://'] = 0
    }

    local url, prot, dom, colon, port, slash, path =
    str:match'((%f[%w]%a+://)(%w[-.%w]*)(:?)(%d*)(/?)([%w_.~!*:@&+$/?%%#=-]*))'

    if (url and
        not (dom..'.'):find('%W%W') and
        protocols[prot:lower()] == (1 - #slash) * #path and
        (colon == '' or port ~= '' and port + 0 < 65536)) then
        return url
    end

    local s, e = vim.regex'\\v(\\u:|\\.{1,2}|\\~)?[/\\\\]([^\\/*?"<>:|]+[/\\\\])*([^\\/*?"<>:|]*\\.\\w+)?':match_str(str)
    if s then return vim.fn.expand(vim.trim(str:sub(s + 1, e))) end
end

-- Open path or url with system default browser.
function M.open_path_or_url(obj)
    local gcwd = vim.fn.getcwd()
    vim.api.nvim_set_current_dir(vim.fn.expand('%:p:h'))
    if (not obj) or
        (vim.fn.glob(obj) == '' and not
        obj:match'^%f[%w]%a+://%w[-.%w]*:?%d*/?[%w_.~!*:@&+$/?%%#=-]*$') then
        vim.api.nvim_set_current_dir(gcwd)
        return
    end
    local cmd
    local args = {}
    if type(pub.start) == "table" then
        cmd = pub.start[1]
        if #(pub.start) >= 2 then
            for i = 2, #(pub.start), 1 do
                table.insert(args, pub.start[i])
            end
        end
    elseif type(pub.start) == "string" then
        cmd = pub.start
    else
        print('Invalid definition of `start`.')
        return
    end
    table.insert(args, obj)
    Handle = vim.loop.spawn(cmd, {
        args = args
    }, vim.schedule_wrap(function ()
        vim.api.nvim_set_current_dir(gcwd)
        Handle:close()
    end))
end

-- Search web.
function M.search_web(mode, site)
    local search_obj
    if mode == 'n' then
        local del_list = {
            ".", ",", "'", "\"",
            ":", ";", "*", "~", "`",
            "(", ")", "[", "]", "{", "}"
        }
        search_obj = lib.encode_url(lib.get_clean_cWORD(del_list))
    elseif mode == 'v' then
        search_obj = lib.encode_url(lib.get_visual_selection())
    end

    M.open_path_or_url(site..search_obj)
end


return M
