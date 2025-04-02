# dotfiles
Collection of dotfiles

```sh
.
├── alacritty
├── gammastep
├── gtk3
├── mako
├── oomox
├── README.md
├── shell
├── sway
├── systemd
├── termite
├── tmux
├── waybar
├── wofi
└── zathura
```

To install these run:
1. `git clone https://github.com/eksop/dotfiles ~/.dot`
2. `cd ~/.dot`
3. `stow <module-to-install>`

## Module: tmux
A pretty, minimalistic and useful tmux configuration for local and remote usage. 

### Installation
1. Install Homebrew (https://github.com/mxcl/homebrew)
2. `brew install zsh`
3. Install prezto (https://github.com/eksop/prezto)
4. Install tmux plugin manager
5. `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
6. Install iTerm2
7. In iTerm2 preferences for your profile set:
```
Character Encoding: Unicode (UTF-8)
Report Terminal Type: xterm-256color
```

### Usage:
Prefix is set to Ctrl-b (make sure you remapped Caps Lock to Ctrl)

#### Shortcuts prefixed with Ctrl-b
| Shortcut | Key |
|----------|-----|
| Last used window | `/` |
| Last used pane | `;` |
| Swap window left | `<` |
| Swap window right | `<` |
| Vertical split | `v` |
| Horizontal split | `h` |
| Kill pane | `x` |
| Kill window | `X` |
| Choose session | `Ctrl-s` |
| Quick window | `Ctrl-q` |

#### Global shortcuts
| Shortcut | Key |
|----------|-----|
| Last used window | `M-/` |
| Zoom in/Zoom out | `M-\` |
| Go to upper pane | `C-<up arrow>` |
| Go to lower pane | `C-<Down Arrow>` |
| Go to left pane | `C-<Left Arrow>` |
| Go to right pane | `C-<Right Arrow>` |
| Previous window | `M-<Left Arrow>` |
| Next window | `M-<Right Arrow>` |
| Previous session | `M-<Up Arrow>` |
| Next session | `M-<Down Arrow>` |

