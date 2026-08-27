local M = {}

local terminal

local function get_terminal()
  if terminal then
    return terminal
  end

  local Terminal = require("toggleterm.terminal").Terminal
  terminal = Terminal:new({
    direction = "float",
    hidden = true,
    close_on_exit = false,
    float_opts = {
      border = "curved",
    },
    on_open = function(term)
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
        buffer = term.bufnr,
        desc = "退出终端输入模式",
      })
    end,
  })

  return terminal
end

local function build_command(filetype, file, options)
  local quoted_file = vim.fn.shellescape(file)

  if filetype == "python" then
    local interactive = options.python_interactive and " -i" or ""
    return "python3" .. interactive .. " " .. quoted_file
  end

  local compiler
  local standard
  if filetype == "c" then
    compiler = "cc"
    standard = "c17"
  elseif filetype == "cpp" then
    compiler = "c++"
    standard = "c++17"
  else
    return nil
  end

  local output_dir = vim.fn.stdpath("cache") .. "/compile-run"
  vim.fn.mkdir(output_dir, "p")

  local stem = vim.fn.fnamemodify(file, ":t:r"):gsub("[^%w_.-]", "_")
  local digest = vim.fn.sha256(file):sub(1, 12)
  local output = string.format("%s/%s-%s", output_dir, stem, digest)

  return table.concat({
    compiler,
    "-std=" .. standard,
    "-Wall",
    "-Wextra",
    "-g",
    quoted_file,
    "-o",
    vim.fn.shellescape(output),
    "&&",
    vim.fn.shellescape(output),
  }, " ")
end

function M.run(options)
  options = options or {}

  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("请先保存当前文件", vim.log.levels.WARN)
    return
  end

  local command = build_command(vim.bo.filetype, file, options)
  if not command then
    vim.notify("F5 当前仅支持 Python、C 和 C++ 文件", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    local ok = pcall(vim.cmd.write)
    if not ok then
      vim.notify("保存文件失败，已取消运行", vim.log.levels.ERROR)
      return
    end
  end

  local cwd = vim.fn.fnamemodify(file, ":p:h")
  local full_command = "cd " .. vim.fn.shellescape(cwd) .. " && " .. command
  local term = get_terminal()
  term:open()
  term:send(full_command, false)
end

function M.toggle()
  get_terminal():toggle()
end

return M
