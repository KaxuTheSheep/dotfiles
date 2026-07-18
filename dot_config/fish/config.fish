set -U fish_greeting ""
set -gx PATH $PATH $HOME/.cargo/bin $HOME/.local/bin
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set -gx TERMCMD "ghostty --class=yazi -e"

# SSH agent
set -gx SSH_AUTH_SOCK ~/.ssh/ssh-agent.sock
ssh-add -l >/dev/null 2>&1
switch $status
    case 2
        # No agent listening — stale socket or none at all
        pkill -u $USER ssh-agent 2>/dev/null
        rm -f $SSH_AUTH_SOCK
        ssh-agent -a $SSH_AUTH_SOCK >/dev/null
        ssh-add ~/.ssh/id_linux
    case 1
        # Agent running, but no key loaded
        ssh-add ~/.ssh/id_linux
end

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
    and not set -q WAYLAND_DISPLAY
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    set -x DBUS_SESSION_BUS_ADDRESS (dbus-daemon --session --print-address --fork)
    echo $DBUS_SESSION_BUS_ADDRESS > /run/user/1000/dbus-session-address
end

# Fastfetch on interactive login
fastfetch
