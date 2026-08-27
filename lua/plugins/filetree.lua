return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "NvimTreeFocus",
      "NvimTreeOpen",
      "NvimTreeToggle",
      "NvimTreeFindFile",
      "NvimTreeCollapse",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "打开或关闭文件树" },
    },
    opts = {},
  },
}
