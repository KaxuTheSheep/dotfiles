set -gx PATH $PATH $HOME/.cargo/bin
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
starship init fish | source
set -gx PATH $PATH $HOME/.local/bin
