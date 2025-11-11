# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository containing configuration files for development tools, shell environment, and terminal emulators. The repository uses a symlink-based installation system to deploy configurations to the home directory.

## Installation System

The repository uses `install.sh` for creating symlinks:
- Files with `.symlink` extension are symlinked directly to `~/.<basename>` (e.g., `gitconfig.symlink` → `~/.gitconfig`)
- Entire directories (`config`, `clojure`) are symlinked to `~/.config` and `~/.clojure` respectively
- Run `./install.sh` to set up symlinks (it will skip existing files)

## Neovim Configuration

The main editor configuration is in `config/nvim/`, using Lua for setup:

### Architecture
- **init.lua**: Main entry point, sets up editor options and loads plugins
- **lua/plugins/init.lua**: Plugin definitions using lazy.nvim package manager
- **lua/plugins/**: Individual plugin configurations (LSP, DAP, formatters, etc.)
- **lua/utils.lua**: Utility functions for keymapping
- **ftplugin/**: Language-specific settings loaded automatically by filetype
- **ftdetect/**: Custom filetype detection rules

### Language Server Setup
LSP configuration is in `config/nvim/lua/plugins/lspconfig.lua`:
- Uses Mason for automatic LSP installation (`ensure_installed` list)
- Language servers configured: angularls, html, basedpyright, gopls, jdtls, lua_ls, svelte, tailwindcss
- Java uses nvim-jdtls with a dedicated ftplugin (`ftplugin/java.lua`)
- Format on save is enabled automatically for all LSPs that support it
- Debug adapter configurations are loaded from `.vscode/launch.json` files if present

### Key Bindings
- Leader key: `,` (general mappings)
- Local leader: `;` (filetype-specific mappings)
- LSP bindings (when in a file with LSP attached):
  - `gd`: Go to definition
  - `gD`: Go to declaration
  - `gt`: Go to type definition
  - `gi`: Go to implementation
  - `gr`: References
  - `K`: Hover documentation
  - `ga`: Code actions
  - `;rn`: Rename
  - `;rf`: Format buffer
- Buffer navigation: `<Leader><Leader>` to toggle between current and previous buffer

### Adding New Language Support
1. Add LSP to `ensure_installed` in `lspconfig.lua`
2. If custom setup needed, add config in `lspconfig.lua` using `create_config()`
3. For filetype-specific settings, create `ftplugin/<filetype>.lua` or `.vim`
4. For custom file detection, add to `ftdetect/`

## Shell Configuration (Zsh)

- **zsh/zshrc.symlink**: Main zsh configuration
- **zsh/zshenv.symlink**: Environment variables
- **zsh/common.zsh**: Shared functions/aliases
- **zsh/functions/**: Autoloaded functions

Environment setup:
- Uses `fnm` for Node.js version management (auto-switches on cd)
- Uses `asdf` for other language version management (Java, etc.)
- JAVA_HOME set via asdf Java plugin
- Python aliased to python3
- Custom prompt: `%1d %% ` (shows current directory)

Key aliases:
- `gac`: git add . && git commit
- `gs`: git status
- `gb`: git branch --show-current
- `venv`: activate Python virtual environment
- `hdoc`: view dotfiles help documentation

## Git Configuration

In `git/gitconfig.symlink`:
- Default branch: `main`
- Pull strategy: rebase
- Push default: current branch only
- Includes `~/.gitconfig-local` for machine-specific settings (not in repo)

## Package Management

**Brewfile**: Defines Homebrew packages and casks
- Terminal emulators: ghostty, wezterm
- Fonts: JetBrains Mono, 3270 Nerd Font
- Core tools: neovim, tmux, fzf, ripgrep, fd, bat, gh
- Language tools: jdtls, ltex-ls, rust, clojure, postgresql
- Version managers: asdf, fnm, uv

To install: `brew bundle` (on macOS)

## Configuration Directories

- `config/nvim/`: Neovim configuration
- `config/ghostty/`: Ghostty terminal emulator config
- `config/wezterm/`: WezTerm terminal emulator config
- `config/kitty/`: Kitty terminal emulator config
- `config/tmux/`: Tmux configuration
- `config/help/`: Custom help documentation

## Common Development Tasks

Since this is a dotfiles repository, most "development" involves:
1. Edit configuration files directly
2. Changes take effect immediately for symlinked files (no rebuild needed)
3. For shell changes: source `~/.zshrc` or restart terminal
4. For nvim changes: restart nvim or reload with `:source ~/.config/nvim/init.lua`

## Git Workflow

Current branch: `feat/remove-mason` (from git status)
- Repository uses conventional branch naming
- Clean working directory maintained
- Recent commits show feature additions and fixes to theme/formatting
