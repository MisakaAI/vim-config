return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 15,
      start_in_insert = true,
      persist_size = true,
      persist_mode = true,
      shade_terminals = true,
    },
    keys = {
      {
        "<F5>",
        function()
          require("config.runner").run()
        end,
        desc = "编译并运行当前文件",
      },
      {
        "<leader><F5>",
        function()
          require("config.runner").run({ python_interactive = true })
        end,
        desc = "调试运行当前文件",
      },
      {
        "<leader>tt",
        function()
          require("config.runner").toggle()
        end,
        desc = "打开或关闭运行终端",
      },
    },
  },
}
