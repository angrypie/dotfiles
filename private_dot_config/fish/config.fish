# Init fisher first
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Aliases
alias n=nvim

# Env
set -gx EDITOR nvim
set -U FZF_DEFAULT_COMMAND "rg --files \$dir"
set -U FZF_LEGACY_KEYBINDINGS 0

# Remove g abbreviation for git. Add abbreviation first to avoid erros if not exist.
abbr --add --global g git && abbr -e g
# Remove standart greeting
set -g fish_greeting

# Set and enable node version for new shell
set --universal nvm_default_version latest

set -gx PATH /opt/homebrew/bin:$PATH

set -gx GOPATH $HOME/go; set -gx GOROOT $HOME/.go; set -gx PATH $GOPATH/bin $PATH; # g-install: do NOT edit, see https://github.com/stefanmaric/g
