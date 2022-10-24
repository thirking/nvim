local cmd = vim.api.nvim_create_user_command

cmd("CodeRun", function(tbl)
    require("utility.comp").run_or_compile(tbl.args)
end, { nargs = "?", complete =
function()
    local option_table = {
        c = { "build", "check" },
        cs = { "build", "clean", "test" },
        lisp = { "build" },
        lua = { "nojit" },
        rust = { "build", "check", "clean", "test" },
        tex = { "biber", "bibtex" },
    }
    if option_table[vim.bo.filetype] then
        return option_table[vim.bo.filetype]
    else
        return {}
    end
end, desc = "Run or compile" })

cmd("BuildDylibs", function(_)
    require("utility.util").build_dylibs()
end, { desc = "Build crates in `$config/rust/` directory" })

cmd("NvimUpgrade", function(tbl)
    local arg = tbl.args
    if arg == "" then arg = nil end
    require("utility.util").nvim_upgrade(arg)
end, {
    nargs = "?",
    complete = function() return { "stable", "nightly" } end,
    desc = "Neovim upgrade"
})

cmd("PushAll", function(tbl)
    local arg_tbl = require("utility.lib").parse_args(tbl.args)
    require("utility.util").git_push_all(arg_tbl)
end, { nargs = "?", desc = "Git push all" })

cmd("SshConfig", function(_)
    require("utility.util").edit_file("$HOME/.ssh/config", false)
end, { desc = "Open ssh configuration" })

cmd("Time", function(_)
    vim.notify(os.date("%Y-%m-%d %a %T"))
end, { desc = "Echo time(May be useful in full screen?)" })
