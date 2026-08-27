return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- 确保最早加载
    lazy = false,    -- 启动就加载（避免闪屏）
    config = function()
      require("kanagawa").setup({
        transparent = true, -- 背景透明
        theme = "dragon", -- wave / dragon / lotus
        background = { dark = "dragon", light = "lotus" },
      })
      vim.cmd("colorscheme kanagawa")
      vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
    end,
  },
}
