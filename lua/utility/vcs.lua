local M = {}
local lib = require('utility/lib')
local uv = vim.loop


local function git_push_async(b_arg)
    Handle_push = uv.spawn('git', {
        args = {'push', 'origin', b_arg}
    },
    function()
        print('Pushed to remote repository.')
        Handle_push:close()
    end)
end

local function git_commit_async(git_root, git_branch, m_arg, b_arg)
    Handle_commit = uv.spawn('git', {
        args = {'commit', '-m', m_arg}
    },
    function ()
        print("Root directory:", git_root)
        print("\nCurrent branch:", git_branch)
        print("\nCommit message:", m_arg)
        --print("Commit message: "..m_arg)
        Handle_commit:close()
        git_push_async(b_arg)
    end)
end

local function git_push_all_async(git_root, git_branch, m_arg, b_arg)
    Handle_add = uv.spawn('git', {
        args = {'add', '*'}
    },
    function ()
        Handle_add:close()
        git_commit_async(git_root, git_branch, m_arg, b_arg)
    end)
end

--- Git push all
function M.git_push_all(...)
    local arg_list = {...}
    local git_root = lib.get_git_root()
    local git_branch

    if git_root then
        git_branch = lib.get_git_branch(git_root)
    else
        print("Not a git repository.")
        return
    end

    if git_branch then
        vim.fn.execute('cd '..git_root)
    else
        print("Not a valid git repository.")
        return
    end

    if #arg_list % 2 == 0 then
        local m_idx = vim.fn.index(arg_list, "-m") + 1
        local b_idx = vim.fn.index(arg_list, "-b") + 1
        local m_arg, b_arg

        if m_idx > 0 and m_idx % 2 == 1 then
            m_arg = arg_list[m_idx + 1]
        elseif m_idx == 0 then
            m_arg = vim.fn.strftime('%y%m%d')
        else
            print("Invalid commit argument.")
            return
        end

        if b_idx > 0 and b_idx % 2 == 1 then
            b_arg = arg_list[b_idx + 1]
        elseif b_idx == 0 then
            b_arg = git_branch
        else
            print("Invalid branch argument.")
            return
        end

        git_push_all_async(git_root, git_branch, m_arg, b_arg)
    else
        print("Wrong number of arguments is given.")
    end
end


return M
