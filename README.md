# Dotfiles

Managed with a bare Git repository. No symlinks, no extra tools.

## Quick Setup

```bash
curl -Lks https://raw.githubusercontent.com/mantis-tobbogan/dotfiles/main/.dotfiles-bootstrap.sh | bash
```

Or manually:

```bash
git clone --bare git@github.com:mantis-tobbogan/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

## What's Included

| Config | Tool |
|--------|------|
| `.bashrc` / `.bash_profile` | Shell (Bash) |
| `starship.toml` | Prompt theme |
| `.dircolors` | LS colors |
| `.config/hypr/` | Hyprland WM |
| `.config/kitty/` | Kitty terminal |
| `.config/nvim/` | Neovim (LazyVim) |
| `.config/zed/` | Zed editor |
| `.config/noctalia/` | Noctalia theme |
| `.config/mise/` | Mise runtime manager |
| `.config/lazydocker/` | Lazydocker |

## Usage

```bash
dotfiles status          # check changes
dotfiles add <file>      # track a new file
dotfiles commit -m "..." # commit changes
dotfiles push            # push to remote
```

## Dependencies

- kitty, hyprland, nvim, starship, mise, zoxide, zed, lazydocker
- Fonts: JetBrainsMono Nerd Font
