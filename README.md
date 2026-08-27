# Neovim 配置

这是一个使用 Lua 编写的 Neovim 配置。入口文件为 `init.lua`，基础编辑器选项集中在
`lua/config/options.lua` 中，按以下顺序加载各模块：

```lua
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
```

先加载基础选项可以确保 Leader 键、netrw 开关等设置在快捷键和插件初始化之前生效。

## 目录结构

```text
.
├── init.lua
└── lua
    ├── config
    │   ├── options.lua    # 基础选项与全局变量
    │   ├── keymaps.lua    # 快捷键映射
    │   ├── autocmds.lua   # 自动命令
    │   └── lazy.lua       # lazy.nvim 的安装与初始化
    └── plugins
        ├── init.lua        # 插件规格入口
        ├── colorscheme.lua # 主题插件配置
        ├── completion.lua  # 自动补全
        ├── filetree.lua    # 文件树
        ├── git.lua         # Git 变更提示与操作
        ├── lsp.lua         # Python/C/C++ 语言服务器
        ├── statusline.lua  # 状态栏
        ├── terminal.lua    # 浮动终端与 F5 运行入口
        ├── treesitter.lua  # 语法解析与高亮
        └── which-key.lua   # 快捷键提示
```

## 使用方式

将本目录作为 Neovim 配置目录使用。Linux/macOS 下默认配置目录通常为
`~/.config/nvim`；也可以通过 `NVIM_APPNAME` 使用一个独立目录。

启动前建议确认：

- 已安装支持 Lua 配置的 Neovim 版本。
- 已安装 Git，且首次启动时能够访问 GitHub，以便自动下载 lazy.nvim。
- F5 运行需要系统中存在 `python3`、`cc` 和 `c++` 中对应当前语言的命令。
- Treesitter `main` 分支需要 Neovim 0.12+、`tree-sitter-cli` 0.26.1+、`tar`、`curl`
  和 C 编译器。当前 `install.sh` 使用 `npm install -g tree-sitter-cli` 安装 CLI；安装后可用
  `tree-sitter --version` 检查版本，输出版本应不低于 0.26.1。
- 如需正常显示文件图标和补全类型图标，终端应使用 Nerd Font。
- 系统存在 Neovim 可用的剪贴板工具；可通过 `:checkhealth provider` 检查。
- 系统已配置 `zh_CN.UTF-8` locale。中文帮助还需要单独安装中文帮助文档；没有中文文档时，
  Neovim 会根据可用情况显示其他语言的帮助。
- 插件配置中包含用于替代 netrw 的文件树插件，否则禁用 netrw 后将无法使用其目录浏览功能。

## 插件管理

本配置使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理插件。启动时，
`lua/config/lazy.lua` 会检查 Neovim 数据目录中是否已经存在 lazy.nvim；如果不存在，
便自动克隆其 `stable` 分支并加入运行时路径。插件规格由 `lua/plugins/` 目录统一导入。

可以把每个插件或一组相关插件拆分成单独文件。例如，新建 `lua/plugins/example.lua`：

```lua
return {
  {
    "author/plugin-name",
    config = function()
      require("plugin-name").setup()
    end,
  },
}
```

常用命令：

| 命令 | 用途 |
| --- | --- |
| `:Lazy` | 打开插件管理界面。 |
| `:Lazy install` | 安装尚未安装的插件。 |
| `:Lazy update` | 更新插件并刷新锁定信息。 |
| `:Lazy sync` | 同步安装、更新和清理操作。 |
| `:Lazy clean` | 清理已从配置中移除的插件。 |
| `:Lazy health` | 检查 lazy.nvim 的运行环境。 |

首次添加插件规格并启动 Neovim 后，lazy.nvim 会负责下载插件，并在配置根目录生成
`lazy-lock.json` 记录插件版本。建议将该文件提交到版本控制，以便在不同设备上复现相同版本。

### 当前主题

当前使用 [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)，相关配置位于
`lua/plugins/colorscheme.lua`：

| 配置 | 作用 |
| --- | --- |
| `priority = 1000` | 提高主题插件的加载优先级，确保它早于大多数界面插件生效。 |
| `lazy = false` | 启动 Neovim 时立即加载主题，避免先显示默认配色再切换造成闪屏。 |
| `transparent = true` | 清除主题的主背景色，使终端背景能够透出。 |
| `theme = "dragon"` | 默认使用颜色较深、对比度较柔和的 Dragon 风格。 |
| `background.dark = "dragon"` | 当 `background=dark` 时使用 Dragon 主题。 |
| `background.light = "lotus"` | 当 `background=light` 时切换到 Lotus 亮色主题。 |
| `colorscheme kanagawa` | 加载 Kanagawa，并根据上述背景映射选择具体风格。 |

主题加载完成后，还会将以下高亮组的背景显式设为 `NONE`：

- `LineNr`：普通行号。
- `SignColumn`：诊断、Git 标记等符号所在列。
- `FoldColumn`：代码折叠提示列。
- `CursorLineNr`：当前光标所在行的行号。

这样可以避免左侧栏残留不透明色块，使整个编辑区的透明效果保持一致。终端本身的背景和
透明度仍需在所使用的终端模拟器中设置。

### 文件树：nvim-tree

[nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) 提供目录浏览、文件操作、Git
状态和诊断信息展示，并使用 `nvim-web-devicons` 显示文件图标。配置已在 Neovim 启动早期
禁用 netrw，nvim-tree 本身则在首次调用命令或快捷键时加载。

| 操作 | 用法 |
| --- | --- |
| 打开或关闭文件树 | `<Leader>e` 或 `:NvimTreeToggle` |
| 打开并聚焦文件树 | `:NvimTreeFocus` |
| 在文件树中定位当前文件 | `:NvimTreeFindFile` |
| 收起所有目录 | `:NvimTreeCollapse` |
| 查看文件树内全部按键 | 在文件树窗口中按 `g?` |

### 语法解析：nvim-treesitter

[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) 提供语言解析器管理及
Tree-sitter 查询，Neovim 使用它们实现结构化语法高亮、语言注入等功能。本配置使用官方
最新的 `main` 分支：插件不延迟加载，更新插件后自动执行 `:TSUpdate`，打开文件时会尝试
通过 `vim.treesitter.start()` 启用已安装解析器的高亮。

`install.sh` 负责安装 Tree-sitter CLI，但不会替用户决定所需语言。首次完成 `:Lazy sync`
后，在 Neovim 中执行以下命令安装本配置常用的解析器：

```vim
:TSInstall lua vim vimdoc bash c cpp python markdown markdown_inline
```

使用 `:TSUpdate` 更新已经安装的解析器。解析器安装失败时，请先确认
`tree-sitter --version` 不低于 0.26.1，并检查 `tar`、`curl` 和 C 编译器是否可用。

### 状态栏：lualine

[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) 在底部显示当前模式、Git 分支、
文件名、诊断数量、编码、文件类型和光标位置等状态。本配置使用 `theme = "auto"` 自动适配
Kanagawa，并启用 nvim-tree 扩展，使文件树窗口中的状态栏保持协调。该插件无需额外按键。

### Git 集成：gitsigns

[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) 在标记列中显示新增、修改和删除的
行，并支持按变更块预览、暂存、还原、比较与查看 blame 信息。相关按键只在 Gitsigns 已附加
的 Git 文件缓冲区中生效。

| 按键 | 作用 |
| --- | --- |
| `]c` / `[c` | 跳到下一个/上一个变更块；diff 模式下保留 Neovim 原行为。 |
| `<Leader>hs` / `<Leader>hr` | 暂存/还原当前变更块；可视模式下作用于选中行。 |
| `<Leader>hS` / `<Leader>hR` | 暂存/还原当前缓冲区的全部变更。 |
| `<Leader>hp` / `<Leader>hi` | 弹窗预览/行内预览当前变更块。 |
| `<Leader>hb` | 显示当前行的完整 Git blame 信息。 |
| `<Leader>hd` | 比较当前文件与 Git 索引。 |
| `ih` | 在操作符等待或可视模式中选择当前变更块。 |

### 快捷键提示：which-key

[which-key.nvim](https://github.com/folke/which-key.nvim) 会在输入快捷键前缀后显示后续可用按键，
帮助发现和记忆映射。它会自动读取 `vim.keymap.set()` 的 `desc`，并将 `<Leader>h` 标记为
“Git 变更块”分组。按 `<Leader>?` 可立即查看当前缓冲区的局部快捷键；故障排查可运行
`:checkhealth which-key`。

### 自动补全：blink.cmp

[blink.cmp](https://github.com/saghen/blink.cmp) 提供 LSP、路径、代码片段和当前缓冲区内容
补全，并支持容错模糊匹配。上游当前正在开发存在大量破坏性变更的 V2，因此本配置按其建议
锁定 `branch = "v1"`，并使用 `friendly-snippets` 补充常见代码片段。模糊匹配器优先使用
Rust 实现，不可用时回退到 Lua 实现并显示提示。

本配置采用官方 `default` 键位预设：

| 按键 | 作用 |
| --- | --- |
| `<C-Space>` | 打开补全菜单；菜单已打开时切换候选项文档。 |
| `<C-n>` / `<C-p>` | 选择下一个/上一个候选项。 |
| `↓` / `↑` | 选择下一个/上一个候选项。 |
| `<C-y>` | 接受当前候选项。 |
| `<C-e>` | 关闭补全菜单。 |
| `<C-b>` / `<C-f>` | 向上/向下滚动候选项文档。 |
| `<Tab>` / `<S-Tab>` | 跳到下一个/上一个代码片段占位符。 |

默认不会自动弹出候选项文档；需要时可按 `<C-Space>` 手动查看。Blink 能提供 LSP 候选项，
其候选项来自下一节配置的语言服务器。

### LSP：Python 与 C/C++

[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) 负责配置 Neovim 内置 LSP 客户端，
[mason.nvim](https://github.com/mason-org/mason.nvim) 和 `mason-lspconfig.nvim` 负责安装并启用
语言服务器。本配置会自动确保以下服务器可用：

| 文件类型 | 语言服务器 | 说明 |
| --- | --- | --- |
| Python | `basedpyright` | 使用 `standard` 类型检查模式。 |
| C / C++ | `clangd` | 启用后台索引、clang-tidy 和详细补全。 |

首次打开对应文件时 Mason 会下载缺少的服务器；可用 `:Mason` 查看安装状态。`clangd` 对单文件
可以直接提供基础功能，在实际 C/C++ 项目中建议由构建系统生成 `compile_commands.json`，以便它
获得准确的头文件路径和编译参数。

LSP 附加到缓冲区后可使用以下按键：

| 按键 | 作用 |
| --- | --- |
| `gd` / `gD` | 跳转到定义/声明。 |
| `gr` / `gi` | 查看引用/跳转到实现。 |
| `K` | 显示光标下符号的文档。 |
| `<Leader>lr` | 重命名符号。 |
| `<Leader>la` | 执行代码操作。 |
| `<Leader>lf` | 格式化当前缓冲区。 |
| `<Leader>ld` | 显示当前行的诊断。 |
| `[d` / `]d` | 跳到上一个/下一个诊断。 |

### F5 编译运行与浮动终端

[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) 提供一个可复用的浮动终端。普通模式下
按 `<F5>` 会先保存当前文件，再按文件类型执行：

| 文件类型 | 执行方式 |
| --- | --- |
| Python | `python3 当前文件` |
| C | `cc -std=c17 -Wall -Wextra -g` 编译后运行。 |
| C++ | `c++ -std=c++17 -Wall -Wextra -g` 编译后运行。 |

C/C++ 可执行文件保存在 Neovim 的缓存目录 `compile-run/` 中，不会写入源码目录。当前 F5 功能
定位为单文件快速运行；多源文件项目仍应使用 Make、CMake 等项目构建命令。

| 按键 | 作用 |
| --- | --- |
| `<F5>` | 保存、编译并运行当前 Python/C/C++ 文件。 |
| `<Leader><F5>` | 调试运行；Python 会使用 `python3 -i`，执行结束后保留交互解释器。 |
| `<Leader>tt` | 打开或关闭同一个浮动终端。 |
| `<Esc><Esc>` | 在浮动终端中退出输入模式，回到终端普通模式。 |

## 基础选项说明

以下配置均来自 `lua/config/options.lua`。

### Leader 键与内置目录浏览

| 配置 | 值 | 说明 |
| --- | --- | --- |
| `vim.g.mapleader` | 空格 | 设置全局 Leader 键，供普通快捷键映射使用。 |
| `vim.g.maplocalleader` | `\` | 设置局部 Leader 键，通常用于文件类型相关映射。 |
| `loaded_netrw` / `loaded_netrwPlugin` | `1` | 禁用内置 netrw 及其插件加载，避免与文件树插件重复接管目录缓冲区。 |

### 界面与交互

| 配置 | 值 | 说明 |
| --- | --- | --- |
| `errorbells` / `visualbell` | `false` | 关闭错误声音和可视响铃。 |
| `mouse` | 空字符串 | 关闭所有模式下的鼠标支持。 |
| `number` | `true` | 显示绝对行号。 |
| `wrap` | `false` | 长行不自动折行显示。 |
| `cursorline` | `true` | 高亮光标所在行。 |
| `ruler` | `true` | 显示光标位置等状态信息。 |
| `signcolumn` | `yes` | 始终显示标记列，避免诊断或 Git 标记出现时文本左右跳动。 |
| `showcmd` | `true` | 在界面中显示尚未执行完的按键命令。 |
| `termguicolors` | `true` | 启用终端真彩色，使主题可以使用 24 位颜色。 |

### 编码与帮助语言

| 配置 | 值 | 说明 |
| --- | --- | --- |
| `encoding` | `utf-8` | 使用 UTF-8 作为 Neovim 内部字符编码。 |
| `langmenu` | `zh_CN.UTF-8` | 优先使用简体中文菜单文本，需要系统 locale 支持。 |
| `helplang` | `cn` | 优先打开中文帮助，需要已安装对应的中文帮助文档。 |
| `scriptencoding` | `utf-8` | 将脚本中的字符按 UTF-8 解释，避免中文注释或字符串出现编码问题。 |

### Tab 与缩进

| 配置 | 值 | 说明 |
| --- | --- | --- |
| `tabstop` | `4` | 一个 Tab 字符显示为 4 列宽。 |
| `shiftwidth` | `4` | 自动缩进以及 `>>`、`<<` 每次移动 4 列。 |
| `softtabstop` | `4` | 编辑时按 Tab 或退格键按 4 列处理。 |
| `expandtab` | `true` | 输入 Tab 时插入空格，而不是实际的 Tab 字符。 |

同时启用了 `filetype plugin indent on`，Neovim 会根据文件类型加载对应插件和缩进规则；
文件类型规则可能进一步覆盖上述通用缩进设置。

### 剪贴板

`clipboard = "unnamedplus"` 让复制、删除和粘贴默认使用系统剪贴板（`+` 寄存器）。
该功能依赖系统剪贴板 provider，例如 Linux 下的 `xclip`、`xsel` 或 Wayland 环境下的
`wl-clipboard`。

### 搜索

| 配置 | 值 | 说明 |
| --- | --- | --- |
| `hlsearch` | `true` | 高亮所有搜索匹配项。 |
| `ignorecase` | `true` | 搜索时默认忽略大小写。 |
| `smartcase` | `true` | 搜索词中包含大写字母时自动改为大小写敏感。 |
| `magic` | `true` | 搜索模式使用 Vim 默认的扩展正则语义。 |

### 响应速度、历史与文件行为

| 配置 | 值 | 说明 |
| --- | --- | --- |
| `history` | `1000` | 保存最多 1000 条命令和搜索历史。 |
| `updatetime` | `250` | 空闲 250 毫秒后触发交换文件写入及 `CursorHold` 等事件。 |
| `timeoutlen` | `400` | 等待组合键映射后续按键的时间为 400 毫秒。 |
| `undofile` | `true` | 启用持久化撤销，关闭文件后仍可保留撤销历史。 |
| `splitbelow` | `true` | 水平分屏默认在当前窗口下方打开。 |
| `splitright` | `true` | 垂直分屏默认在当前窗口右侧打开。 |
| `lazyredraw` | `true` | 执行宏等批量操作时减少中间重绘。 |

### 命令行补全与匹配提示

| 配置 | 值 | 说明 |
| --- | --- | --- |
| `wildmenu` | `true` | 在命令行补全时显示候选菜单。 |
| `wildignore` | `*.o`、`*~`、`*.pyc` | 在文件名补全时忽略目标文件、备份文件和 Python 字节码。 |
| `completeopt` | `menuone,noselect` | 即使只有一个候选项也显示补全菜单，并且默认不选中候选项。 |
| `showmatch` | `true` | 输入右括号时短暂跳转或高亮与之匹配的左括号。 |
| `matchtime` | `2` | 匹配括号提示持续 2 个十分之一秒，即约 200 毫秒。 |

## 调整配置

通用选项可直接在 `lua/config/options.lua` 中修改。例如，将缩进宽度改为 2 个空格：

```lua
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
```

保存后重启 Neovim 即可生效。也可以在 Neovim 中使用 `:source $MYVIMRC` 重新加载入口
文件；涉及插件初始化的改动通常更适合重启后验证。
