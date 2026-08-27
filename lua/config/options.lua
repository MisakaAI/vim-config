local opt = vim.opt
local g = vim.g

-- leader（建议放在最前面）
g.mapleader = " "
g.maplocalleader = "\\"

-- nvim-tree 取代 netrw，避免目录缓冲区互相接管
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- 禁止响铃
opt.errorbells = false
opt.visualbell = false

-- 关闭鼠标
opt.mouse = ""

-- 行号/不折行/高亮当前行/标尺
opt.number = true
opt.wrap = false
opt.cursorline = true
opt.ruler = true
opt.signcolumn = "yes"

-- 编码/语言
opt.encoding = "utf-8"
opt.langmenu = "zh_CN.UTF-8"
opt.helplang = "cn"
vim.cmd("scriptencoding utf-8")

-- Tab/缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

-- 使用系统剪贴板（需要系统安装对应 clipboard provider）
opt.clipboard = "unnamedplus"

-- 搜索
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- 显示输入命令
opt.showcmd = true

-- 历史
opt.history = 1000

-- 响应速度/文件行为
opt.updatetime = 250
opt.timeoutlen = 400
opt.undofile = true
opt.splitbelow = true
opt.splitright = true

-- filetype
vim.cmd("filetype plugin indent on")

-- wildmenu / wildignore
opt.wildmenu = true
opt.wildignore = { "*.o", "*~", "*.pyc" }

-- completeopt
opt.completeopt = { "menuone", "noselect" }

-- magic / lazyredraw / showmatch
opt.magic = true
opt.lazyredraw = true
opt.showmatch = true
opt.matchtime = 2

-- 颜色：Neovim 不需要 t_Co，建议开 truecolor
opt.termguicolors = true
