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
