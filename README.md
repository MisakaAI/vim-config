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
        └── init.lua       # 插件规格入口
```

## 使用方式

将本目录作为 Neovim 配置目录使用。Linux/macOS 下默认配置目录通常为
`~/.config/nvim`；也可以通过 `NVIM_APPNAME` 使用一个独立目录。

启动前建议确认：

- 已安装支持 Lua 配置的 Neovim 版本。
- 已安装 Git，且首次启动时能够访问 GitHub，以便自动下载 lazy.nvim。
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
