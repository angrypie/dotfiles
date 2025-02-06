**install chezmoi on mac**

	brew install chezmoi

**apply existing config**

	chezmoi init --apply angrypie

**install on any system**

    sh -c "$(curl -fsLS https://chezmoi.io/get)"

### Setup MacOS

Install brew

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Install cli tools

    brew intall tmux fish fzf ripgrep fd bat scc bob

Install neovim using bob verison manager

    bob use stable

Increase keyboard repeat rate to faster neovim navigation

    sudo defaults write -g KeyRepeat -int 2 && sudo defaults write -g InitialKeyRepeat -int 15
