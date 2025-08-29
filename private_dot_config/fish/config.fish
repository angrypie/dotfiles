# Some macos commands
# Increase keyboard repeat rate to faster neovim navigation
# sudo defaults write -g KeyRepeat -int 2
# sudo defaults write -g InitialKeyRepeat -int 15
# Init fisher first
#
if not functions -q fisher
	set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
	curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
	fish -c fisher
end

# fish auto expand command n to nvim
abbr --add --global n nvim
abbr --add --global updots atuin scripts run updots

# Env, editor, history
set -gx EDITOR nvim
set -U FZF_DEFAULT_COMMAND "rg --files \$dir" # exclude .gitigore files
set -U FZF_LEGACY_KEYBINDINGS 0
bind \ef '__fzf_open --editor' # open file in default editor on <Option-f>
bind \ct 'tmux capture-pane -p -S -E- | sed "/^\$/N;/^\n\$/D" | nvim -c "\$"' # open tmux buffer in nvim on <Control-t>

# Remove standart greeting
set -g fish_greeting

# Set and enable node version for new shell
set --universal nvm_default_version lts

fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.local/share/bob/nvim-bin # https://github.com/MordechaiHadad/bob

# g is a golang plugin manager writen in fish.
abbr --add --global g git && abbr -e g # Remove g abbreviation for git. Add abbreviation first to avoid erros if not exist.
set -gx GOPATH $HOME/go; set -gx GOROOT $HOME/.go; set -gx PATH $GOPATH/bin $PATH; # g-install: do NOT edit, see https://github.com/stefanmaric/g

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# atuin initialization
atuin init fish | source


# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/el/.lmstudio/bin
# End of LM Studio CLI section

