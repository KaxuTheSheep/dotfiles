set -U fish_greeting ""
set -gx PATH $PATH $HOME/.cargo/bin $HOME/.local/bin
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml

# SSH agent
if not pgrep -u $USER ssh-agent > /dev/null
    eval (ssh-agent -c) > /dev/null
end
ssh-add ~/.ssh/id_linux 2>/dev/null

# Aliases
alias ls="eza"
alias cat="bat"
alias ff="fastfetch"
alias ll="eza -lah --git"
alias tree="eza --tree --all"

# Functions
function fdf
    fd $argv | fzf
end

function cdf
    cd (fd -t d --hidden | fzf $argv)
end

function vf
    set file (fd -t f . --hidden --exclude node_modules --exclude .git | fzf --query "$argv" --exact --height 40% --reverse)
    if test -n "$file"
        nvim $file
    end
end

function uvf
    set file (fd -t f . / --hidden --exclude node_modules --exclude .git 2>/dev/null | fzf --query "$argv" --exact --height 40% --reverse)
    if test -n "$file"
        nvim $file
    end
end

function cf
    set file (fd -t f . --hidden --exclude node_modules --exclude .git | fzf --query "$argv" --exact --height 40% --reverse)
    if test -n "$file"
        bat $file
    end
end

function ucf
    set file (fd -t f . / --hidden --exclude node_modules --exclude .git 2>/dev/null | fzf --query "$argv" --exact --height 40% --reverse)
    if test -n "$file"
        bat $file
    end
end

# Zoxide
zoxide init fish | source

# Starship
starship init fish | source

# Start niri if on TTY1 and not already running
if status is-login
    and test (tty) = /dev/tty1
    and not pgrep -u $USER niri > /dev/null
    set -x XDG_RUNTIME_DIR /run/user/(id -u)
    while not loginctl show-user $USER 2>/dev/null | grep -q "State=active"
        sleep 1
    end
    exec niri-session
end

# Fastfetch on interactive login
fastfetch
