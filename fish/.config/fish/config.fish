set -U fish_greeting ""
set -gx PATH $PATH $HOME/.cargo/bin $HOME/.local/bin
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml

if not pgrep -u $USER ssh-agent > /dev/null
    eval (ssh-agent -c) > /dev/null
end
ssh-add ~/.ssh/id_dotfiles 2>/dev/null
ssh-add ~/.ssh/id_obsidian 2>/dev/null

starship init fish | source
