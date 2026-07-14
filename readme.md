**install chezmoi on mac**

	brew install chezmoi

**apply existing config**

	chezmoi init --apply angrypie

**install on any system**

    sh -c "$(curl -fsLS https://chezmoi.io/get)"

### Setup MacOS

Install brew

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Install Atuin (shell history)

    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh


Install cli tools

    brew install tmux fish fzf ripgrep fd bat scc bob

Install neovim using bob verison manager

    bob use stable

Install tmux plugin manager

    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

Increase keyboard repeat rate to faster neovim navigation

    sudo defaults write -g KeyRepeat -int 2 && sudo defaults write -g InitialKeyRepeat -int 15
