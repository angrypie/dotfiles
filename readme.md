**install chezmoi on mac**

	brew install chezmoi

**apply existing config to current system**

	chezmoi init --apply angrypie

**add changes from current system to config**

    chezmoi re-add --verbose

**use atuin to the same re-add script**

	atuin scripts run updots 

**install on any system**

    sh -c "$(curl -fsLS https://chezmoi.io/get)"

### Setup MacOS

Install brew

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Install Atuin (shell history)

    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh


Install cli tools

    brew intall tmux fish fzf ripgrep fd bat scc bob

Install neovim using bob verison manager

    bob use stable

Increase keyboard repeat rate to faster neovim navigation

    sudo defaults write -g KeyRepeat -int 2 && sudo defaults write -g InitialKeyRepeat -int 15
