return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = desc,
            silent = true,
          })
        end

        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "下一个 Git 变更块")

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "上一个 Git 变更块")

        map("n", "<leader>hs", gitsigns.stage_hunk, "暂存变更块")
        map("n", "<leader>hr", gitsigns.reset_hunk, "还原变更块")
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "暂存选中变更")
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "还原选中变更")
        map("n", "<leader>hS", gitsigns.stage_buffer, "暂存整个缓冲区")
        map("n", "<leader>hR", gitsigns.reset_buffer, "还原整个缓冲区")
        map("n", "<leader>hp", gitsigns.preview_hunk, "预览变更块")
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, "行内预览变更块")
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, "查看当前行 Git 归属")
        map("n", "<leader>hd", gitsigns.diffthis, "比较当前文件")
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "选择 Git 变更块")
      end,
    },
  },
}
