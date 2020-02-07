" 关闭方向键盘
"noremap <Up> <Nop>
"noremap <Down> <Nop>
"noremap <Left> <Nop>
"noremap <Right> <Nop>
" 主题
colors zenburn
" 256配色
set t_Co=256
" 禁止 vim 发出滴滴声
set noerrorbells
" 关闭鼠标
set mouse-=a
" 显示行号
set number
" 禁止折行
set nowrap
" 高亮显示当前行
set cursorline
" 高亮显示当前列
" set cursorcolumn
" 语法高亮
syntax on
syntax enable
" 显示标尺(在右下角显示当前行信息)
set ruler
" 语言设置
set encoding=utf-8
set langmenu=zh_CN.UTF-8
set helplang=cn
scriptencoding utf-8
" 设置编辑时制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 用空格代替Tab
" set expandtab
" %retab!
" TAB替换为空格
set noexpandtab
%retab!
" 让 vim 把连续数量的空格视为一个制表符
" set softtabstop=4
" vim 显示空格
" set list
" set listchars=tab:>-,trail:-
" 自动缩进
" set autoindent
" set cindent
" 开启智能对齐
" set smartindent
" 共享剪贴板
set clipboard+=unnamed
" 搜索高亮
set hlsearch
"搜索忽略大小写
set ignorecase
" 显示出输入的命令
set showcmd
" 历史记录条数1000
set history=1000
" 自动检测文件类型并启动相关缩进插件
filetype plugin indent on
" 不同文件类型加载相应插件
filetype plugin on
" 检查文件类型
filetype on
" 关闭兼容模式
set nocompatible
" vim 命令行模式智能补全
set wildmenu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
" 关闭智能补全时的预览窗口
set completeopt=longest,menu
" 拼写检查
" set spell
" 设置正则表达式(除了 $ . * ^ 之外其他元字符都要加反斜杠)
set magic
" Don't redraw while executing macros (good performance config)
set lazyredraw
" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 按F5一键编译并运行
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
        exec "w"
        if &filetype == 'c'
           exec "!g++ % -DLOCAL -o   %<"
           exec "!time ./%<"
        elseif &filetype == 'cpp'
           exec "!g++ % -std=c++11 -DLOCAL -Dxiaoai -o %<"
           exec "!time ./%<"
        elseif &filetype == 'java'
           exec "!javac %"
           exec "!time java %<"
        elseif &filetype == 'sh'
           :!time bash %
        elseif &filetype == 'python'
        exec "!time python3 %"
        endif
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 按 F2 插入文件开头
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F2> :call SetTitle()<CR>
func SetTitle()
    " 如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1,"#!/usr/bin/env bash")
        call append(line("."), "")
        call append(line(".")+1, "# File Title: ".expand("%"))
        call append(line(".")+2, "# Author: Selphia")
        call append(line(".")+3, "# Mail: LoliSound@gmail.com")
        call append(line(".")+4, "# Time: ".strftime("%c"))
        call append(line(".")+5, "# Version: ")
        call append(line(".")+6, "")
    " 如果文件类型为.cpp文件
    elseif &filetype == 'cpp'
        call setline(1,  "/***************************************")
        call append(line("."), "# File Title: ".expand("%"))
        call append(line(".")+1, "# Author: Selphia")
        call append(line(".")+2, "# Mail: LoliSound@gmail.com")
        call append(line(".")+3, "# Time: ".strftime("%c"))
        call append(line(".")+4, "# Version: ")
        call append(line(".")+5, "***************************************/")
        call append(line(".")+6, "")
        call append(line(".")+7, "#include<iostream>")
        call append(line(".")+8, "using namespace std;")
        call append(line(".")+9, "")
        call append(line(".")+10, "int main()")
        call append(line(".")+11, "{")
        call append(line(".")+12, "")
        call append(line(".")+13, "    return 0;")
        call append(line(".")+14, "}")
        call append(line(".")+15, "")
    " 如果文件类型为.c文件
    elseif &filetype == 'c'
        call setline(1,  "/***************************************")
        call append(line("."), "# File Title: ".expand("%"))
        call append(line(".")+1, "# Author: Selphia")
        call append(line(".")+2, "# Mail: LoliSound@gmail.com")
        call append(line(".")+3, "# Time: ".strftime("%c"))
        call append(line(".")+4, "# Version: ")
        call append(line(".")+5, "***************************************/")
        call append(line(".")+6, "#include<stdio.h>")
        call append(line(".")+7, "")
        call append(line(".")+8, "int main()")
        call append(line(".")+9, "{")
        call append(line(".")+10, "")
        call append(line(".")+11, "    return 0;")
        call append(line(".")+12, "}")
        call append(line(".")+13, "")
    " 如果文件类型为.py文件
    elseif &filetype == 'python'
        call setline(1, "#!/usr/bin/env python3")
        call append(line("."), "# -*- coding: utf-8 -*-")
        call append(line(".")+1, "")
        call append(line(".")+2, "# File Title: ".expand("%"))
        call append(line(".")+3, "# Author: Selphia")
        call append(line(".")+4, "# Mail: LoliSound@gmail.com")
        call append(line(".")+5, "# Time: ".strftime("%c"))
        call append(line(".")+6, "# Version: ")
        call append(line(".")+7, "")
    " 如果文件类型为.html文件
    "elseif &filetype == 'html'
    "    call setline(1, "<!doctype html>")
    "    call append(line("."), "<html>")
    "    call append(line(".")+1, "<head>")
    "    call append(line(".")+2, "<meta charset=\"utf-8\">")
    "    c all append(line(".")+3, "<link rel=\"shortcut icon\" href=\"favicon.ico\"/>")
    "    call append(line(".")+4, "<link rel=\"stylesheet\" type=\"text/css\" href=\"\" />")
    "    call append(line(".")+5, "<title> Untitled </title>")
    "    call append(line(".")+6, "</head>")
    "    call append(line(".")+7, "<body>")
    "    call append(line(".")+8, "</body>")
    "    call append(line(".")+9, "</html>")
    "    call append(line(".")+10, "")
    " 如果文件类型为.css文件
    "elseif &filetype == 'css'
    "    call setline(1, "@charset \"utf-8\";")
    "    call append(line("."), "/* CSS Document */")
    "    call append(line(".")+1, "")
    "    call append(line(".")+2, "html,body {")
    "    call append(line(".")+3, "    margin:0px auto;")
    "    call append(line(".")+4, "    padding:0px;")
    "    call append(line(".")+5, "    font-family:\"Microsoft jhenghei\";")
    "    call append(line(".")+6, "}")
    "    call append(line(".")+7, "div,h1,p,a,img {")
    "    call append(line(".")+8, "    margin:0px auto;")
    "    call append(line(".")+9, "    padding:0px;")
    "    call append(line(".")+10, "}")
    "    call append(line(".")+11, "a {")
    "    call append(line(".")+12, "    text-decoration:none;")
    "    call append(line(".")+13, "}")
    "    call append(line(".")+14, "")
    else
        call setline(1, "# File Title: ".expand("%"))
        call append(line("."), "# Author: Selphia")
        call append(line(".")+1, "# Mail: LoliSound@gmail.com")
        call append(line(".")+2, "# Time: ".strftime("%c"))
        call append(line(".")+3, "# Version: ")
        call append(line(".")+4, "")
    endif
    " 新建文件后，自动定位到文件末尾
    normal G
endfunc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim 配置变更立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 按 F8 打开目录树
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F8> :NERDTree %<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 颜色显示插件 (https://github.com/lilydjwg/colorizer)
" 自动补全 ( vim-taglist)(apt install exuberant-ctags)
" HTML/CSS 快速编写插件 (https://github.com/mattn/emmet-vim)
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
" 目录树 (已设置按 <F8> 打开)
" ---> https://github.com/scrooloose/nerdtree
" ---> https://www.vim.org/scripts/script.php?script_id=1658
