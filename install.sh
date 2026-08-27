#!/bin/bash

# 删除旧版本
sudo rm -r /opt/nvim-linux-x86_64

# 清空配置（必需）
sudo rm -r ~/.config/nvim

# 清空配置（可选）
sudo rm -r ~/.local/share/nvim
sudo rm -r ~/.local/state/nvim
sudo rm -r ~/.cache/nvim

# 用于Linux系统的预构建二进制文件
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

# echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> /etc/zsh/zshrc
sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
