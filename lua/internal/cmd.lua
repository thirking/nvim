local cmd = vim.api.nvim_create_user_command

cmd("CodeRun", function(tbl)
  require("utility.run").code_run(tbl.args)
end, {
  nargs = "?",
  complete = function()
    local option_table = {
      c = { "build", "check" },
      cs = { "build", "clean", "test" },
      fsharp = { "build", "clean", "test" },
      lisp = { "build" },
      lua = { "lua", "jit" },
      rust = { "build", "check", "clean", "test" },
      tex = { "biber", "bibtex" },
    }
    if option_table[vim.bo.filetype] then
      return option_table[vim.bo.filetype]
    else
      return {}
    end
  end,
  desc = "Run or compile"
})

cmd("BuildDylibs", function(_)
  require("utility.util").build_dylibs()
end, { desc = "Build crates in `$config/rust/` directory" })

cmd("CreateProject", function(tbl)
  require("utility.template"):create_project(tbl.args)
end, {
  nargs = "?",
  complete = function()
    local template = require("utility.template")
    template:init()
    return vim.tbl_keys(template.templates)
  end
  ,
  desc = "Create project"
})

cmd("GlslViewer", function(tbl)
  require("utility.glsl").start(0, tbl.fargs)
end, { nargs = "*", desc = "Start glslViewer", complete = "file" })

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
  require("logit").push_all(arg_tbl)
end, { nargs = "?", desc = "Git push all" })

cmd("Time", function(_)
  vim.notify(vim.fn.strftime("%Y-%m-%d %a %T"))
end, { desc = "Print current time (May be useful in full screen?)" })
