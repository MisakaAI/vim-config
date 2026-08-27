return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>h", group = "Git 变更块" },
        { "<leader>l", group = "LSP" },
        { "<leader>t", group = "终端" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "显示当前缓冲区快捷键",
      },
    },
  },
}
