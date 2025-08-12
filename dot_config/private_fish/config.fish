set -x PATH ~/.local/bin $PATH

if status is-interactive
    mise activate fish | source
    starship init fish | source
    atuin init fish | source
    zoxide init fish | source
    # Commands to run in interactive sessions can go here
    bind up _atuin_bind_up
end
