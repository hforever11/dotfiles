# dotfiles

My dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Setup

```sh
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ShoFukunaga/dotfiles
```

## Usage

```sh
# Pull latest changes and apply
chezmoi update

# Edit a managed file
chezmoi edit ~/.config/nvim/init.lua

# See what would change
chezmoi diff

# Apply changes
chezmoi apply
```

## Docs

- [Docs Index](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/docs/README.md)
- [tmux Commands](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/docs/tmux/COMMANDS.md)
- [Neovim Docs](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/docs/nvim/README.md)
