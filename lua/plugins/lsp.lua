return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {},
      },
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "basedpyright", "clangd" },
        automatic_enable = { "basedpyright", "clangd" },
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = true },
        signs = true,
        underline = true,
        virtual_text = { spacing = 2, source = "if_many" },
      })

      local group = vim.api.nvim_create_augroup("config-lsp-keymaps", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = args.buf,
              desc = desc,
              silent = true,
            })
          end

          map("n", "gd", vim.lsp.buf.definition, "跳转到定义")
          map("n", "gD", vim.lsp.buf.declaration, "跳转到声明")
          map("n", "gr", vim.lsp.buf.references, "查看引用")
          map("n", "gi", vim.lsp.buf.implementation, "跳转到实现")
          map("n", "K", vim.lsp.buf.hover, "显示符号文档")
          map("n", "<leader>lr", vim.lsp.buf.rename, "重命名符号")
          map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "代码操作")
          map("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, "格式化当前缓冲区")
          map("n", "<leader>ld", vim.diagnostic.open_float, "显示当前行诊断")
          map("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "上一个诊断")
          map("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "下一个诊断")
        end,
      })
    end,
  },
}
