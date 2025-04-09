# Optimized Neovim Configuration

A fast, feature-rich Neovim configuration optimized for performance and efficiency. This setup is designed for developers who need a powerful environment without lag or delays. It supports multiple programming languages with LSP integration, modern UI, testing frameworks, and debugging capabilities.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Core Features](#core-features)
- [Performance Optimizations](#performance-optimizations)
- [Plugin Details](#plugin-details)
  - [User Interface](#user-interface)
  - [Navigation](#navigation)
  - [Editing and Coding](#editing-and-coding)
  - [Git Integration](#git-integration)
  - [LSP (Language Server Protocol)](#lsp-language-server-protocol)
  - [Language Support](#language-support)
  - [Testing and Debugging](#testing-and-debugging)
  - [AI Assistance](#ai-assistance)
- [Key Mappings](#key-mappings)
  - [General](#general-keymaps)
  - [File Navigation](#file-navigation-keymaps)
  - [Editing](#editing-keymaps)
  - [LSP and Code Actions](#lsp-and-code-actions-keymaps)
  - [Git Operations](#git-operations-keymaps)
  - [Testing](#testing-keymaps)
  - [Debugging](#debugging-keymaps)
- [Language Server Setup](#language-server-setup)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

## Overview

This Neovim configuration focuses on performance, rapid startup time, and efficient resource usage while providing a rich development environment. Key optimizations include:

- Lazy-loading plugins on demand
- Optimized LSP configurations with performance tuning
- Efficient UI elements with minimal overhead
- Advanced file navigation with `fzf-lua` and `oil.nvim`
- Performance safeguards for large files
- Comprehensive language support with custom optimizations
- Modern coding features (completion, snippets, linting, formatting)

## Installation

### Prerequisites

- Neovim 0.9.0 or higher
- Git
- A Nerd Font (for icons)
- Node.js (for some language servers)
- `ripgrep` (for fast file search)
- `fd` (for file finding)

### Basic Installation

1. Back up your existing Neovim configuration if you have one:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone the repository:

```bash
git clone https://github.com/thenameiswiiwin/nvim.git ~/.config/nvim
```

3. Start Neovim:

```bash
nvim
```

4. On first startup, Lazy.nvim will automatically install all plugins.

5. For LSP servers, open Neovim and run `:Mason` to install language servers.

## Core Features

### 1. Fast Navigation

- **FZF-Lua**: Ultra-fast fuzzy finding across files, buffers, and code
- **Oil.nvim**: File explorer that works within Neovim's buffer system
- **Harpoon**: Quick jumps between your most used files

### 2. Intelligent Code Assistance

- **LSP Integration**: Configured for optimal performance with TypeScript, Rust, Go, PHP, Vue, and more
- **nvim-cmp**: Completion engine with snippet support
- **GitHub Copilot**: AI-powered code suggestions

### 3. Powerful Editing Capabilities

- **Treesitter**: Smart syntax highlighting and code navigation
- **Mini.pairs**: Auto-closing brackets and quotes
- **Formatting & Linting**: Automatic code formatting and linting on save (configurable)
- **Flash.nvim**: Enhanced motions and navigation

### 4. Developer Tools

- **DAP**: Debug Adapter Protocol for debugging support
- **Neotest**: Testing framework integration
- **Git Integration**: Signs, blame, and operations directly within Neovim

### 5. Minimal & Efficient UI

- **Lualine**: Lightweight status line with essential information
- **Rose Pine**: Beautiful, optimized color scheme
- **Zen Mode**: Distraction-free coding

## Performance Optimizations

This configuration includes numerous performance optimizations:

- **Plugin Lazy Loading**: Most plugins only load when actually needed
- **LSP Performance Tuning**: Reduced diagnostics frequency, optimized inlay hints, cached operations
- **Large File Handling**: Automatically disables heavy features for large files
- **FZF Optimization**: Configured for maximum speed with smart caching
- **Memory Management**: Reduced treesitter parser load, optimized completion engine
- **Throttled Operations**: Linting, formatting, and other intensive operations are throttled
- **Efficient UI**: Minimal status line, optimized highlighting
- **File Watchers**: Limited and optimized to reduce disk operations

## Plugin Details

### User Interface

#### Rose Pine Theme

A modern low-contrast theme for better focus and reduced eye strain.

#### Lualine

Minimal status line showing essential information like mode, file, git status, and diagnostics.

#### Mini.icons

Provides icons for files and filetypes with minimal overhead.

#### Which-key

Shows available keybindings in a popup - only loaded when needed.

#### Zen Mode

Toggle distraction-free coding mode with `<leader>zz` or `<leader>zZ`.

### Navigation

#### FZF-Lua

Ultra-fast fuzzy finder with optimized performance:

- `<leader>ff`: Find files
- `<leader>fg`: Live grep
- `<leader>fb`: Browse buffers
- `<leader>fr`: Recent files

#### Oil.nvim

File explorer that works within Neovim's buffer system:

- `<leader>e`: Open Oil explorer
- `-`: Navigate up to parent directory
- `<CR>`: Open selected file or directory

#### Harpoon

Quick navigation between marked files:

- `<leader>ha`: Add current file to Harpoon
- `<leader>hm`: Show Harpoon menu
- `<leader>1-5`: Jump to marked files
- `<leader>hn/hp`: Navigate between marked files

#### Flash.nvim

Enhanced motions for faster navigation:

- `s`: Start Flash jump
- `S`: Flash Treesitter navigation

### Editing and Coding

#### nvim-cmp

Completion engine with multiple sources:

- LSP completions
- Snippet completions
- Copilot suggestions
- Buffer text completions
- Path completions

#### LuaSnip

Snippet engine with VS Code snippet support.

#### Mini.pairs

Automatic bracket and quote pairing.

#### Conform.nvim

Code formatting engine:

- Automatic formatting on save (toggleable)
- Format with `<leader>cf`
- Toggle with `:FormatToggle`

#### nvim-lint

Linting framework:

- Automatic linting on save
- Manual linting with `<leader>cl`

#### Treesitter

Smart syntax highlighting and code navigation:

- Enhanced syntax highlighting
- Structural navigation
- Text objects based on code structure

### Git Integration

#### Gitsigns.nvim

Git integration in the sign column:

- `]g/[g`: Navigate between hunks
- `<leader>ghs`: Stage hunk
- `<leader>ghr`: Reset hunk
- `<leader>ghb`: Show blame for current line

### LSP (Language Server Protocol)

#### nvim-lspconfig

Core LSP client configuration:

- `gd`: Go to definition
- `K`: Show hover information
- `<leader>ca`: Code actions
- `<leader>cr`: Rename symbol
- `<leader>cf`: Find references
- `<leader>th`: Toggle inlay hints

#### mason.nvim

LSP server installer:

- `:Mason`: Open Mason UI
- Automatic installation of required language servers

### Language Support

This configuration includes optimized support for:

- **TypeScript/JavaScript**: Using vtsls for better performance
- **Rust**: With rust-analyzer and crates.nvim
- **Go**: With gopls and dap-go
- **PHP**: With intelephense
- **Vue**: With volar
- **Web**: HTML, CSS, Tailwind
- **JSON**: With schema support

### Testing and Debugging

#### Neotest

Testing framework integration:

- `<leader>tt`: Run nearest test
- `<leader>tf`: Run test file
- `<leader>ts`: Run test suite
- `<leader>td`: Debug nearest test

#### nvim-dap

Debug Adapter Protocol client:

- `<leader>db`: Toggle breakpoint
- `<leader>dc`: Start/continue debugging
- `<leader>di`: Step into
- `<leader>do`: Step out
- `<leader>dO`: Step over

### AI Assistance

#### GitHub Copilot

AI-powered code completion and suggestions:

- Automatic suggestions as you type
- `<C-y>`: Accept suggestion
- `<M-k>`: Accept word
- `<M-l>`: Accept line
- `<M-CR>`: Open suggestions panel

## Key Mappings

### General Keymaps

| Mapping            | Description                             |
| ------------------ | --------------------------------------- |
| `<Space>`          | Leader key                              |
| `<leader><leader>` | Reload current file                     |
| `<C-s>`            | Save file                               |
| `<leader>ut`       | Toggle between dark/light theme         |
| `<leader>zz`       | Toggle Zen Mode (with line numbers)     |
| `<leader>zZ`       | Toggle Zen Mode (full distraction-free) |

### File Navigation Keymaps

| Mapping         | Description                    |
| --------------- | ------------------------------ |
| `<leader>e`     | Open Oil file explorer         |
| `<leader>ff`    | Find files with FZF            |
| `<leader>fg`    | Live grep with FZF             |
| `<leader>fb`    | Browse buffers                 |
| `<leader>fr`    | Browse recent files            |
| `<leader>ha`    | Add file to Harpoon            |
| `<leader>hm`    | Open Harpoon menu              |
| `<leader>1-5`   | Jump to Harpoon files 1-5      |
| `<leader>hn/hp` | Navigate between Harpoon files |
| `<C-h/j/k/l>`   | Navigate between splits        |

### Editing Keymaps

| Mapping        | Description                          |
| -------------- | ------------------------------------ |
| `J/K` (visual) | Move selected lines down/up          |
| `J` (normal)   | Join lines keeping cursor position   |
| `<leader>p`    | Paste without yanking                |
| `<leader>y`    | Yank to system clipboard             |
| `<leader>d`    | Delete without yanking               |
| `<leader>sr`   | Search and replace word under cursor |
| `<leader>cf`   | Format document                      |
| `<leader>cl`   | Lint current file                    |
| `<leader>cx`   | Make file executable                 |

### LSP and Code Actions Keymaps

| Mapping      | Description              |
| ------------ | ------------------------ |
| `gd`         | Go to definition         |
| `K`          | Show hover information   |
| `<leader>ca` | Code actions             |
| `<leader>cr` | Rename symbol            |
| `<leader>cf` | Find references          |
| `<leader>th` | Toggle inlay hints       |
| `[d/]d`      | Previous/next diagnostic |
| `<leader>xd` | Show diagnostic details  |
| `<leader>cm` | Open Mason               |

### Git Operations Keymaps

| Mapping       | Description        |
| ------------- | ------------------ |
| `[g/]g`       | Previous/next hunk |
| `<leader>ghs` | Stage hunk         |
| `<leader>ghr` | Reset hunk         |
| `<leader>ghb` | Blame line         |
| `<leader>ghp` | Preview hunk       |
| `<leader>gs`  | Git status         |
| `<leader>gc`  | Git commits        |
| `<leader>gb`  | Git branches       |

### Testing Keymaps

| Mapping      | Description                       |
| ------------ | --------------------------------- |
| `<leader>tt` | Run nearest test                  |
| `<leader>tf` | Run file tests                    |
| `<leader>ts` | Run test suite                    |
| `<leader>td` | Debug nearest test                |
| `<leader>to` | Show test output                  |
| `<leader>tp` | Toggle output panel               |
| `<leader>tm` | Toggle test summary               |
| `[t/]t`      | Jump to previous/next failed test |

### Debugging Keymaps

| Mapping      | Description                |
| ------------ | -------------------------- |
| `<leader>db` | Toggle breakpoint          |
| `<leader>dB` | Set conditional breakpoint |
| `<leader>dc` | Start/continue debugging   |
| `<leader>dC` | Run to cursor              |
| `<leader>di` | Step into                  |
| `<leader>do` | Step out                   |
| `<leader>dO` | Step over                  |
| `<leader>dt` | Terminate debug session    |
| `<leader>du` | Toggle DAP UI              |
| `<leader>de` | Evaluate expression        |

## Language Server Setup

This configuration includes optimized LSP setups for multiple languages:

### TypeScript/JavaScript

- Using vtsls for better performance
- Intelligent inlay hints and completion
- Path imports and refactoring support

### Rust

- Full rust-analyzer integration
- crates.nvim for Cargo.toml management
- Auto-loading of clippy lints

### Go

- Optimized gopls configuration
- Testing tools integration
- Debug adapter for delve

### PHP

- Intelephense for intelligent completion
- PHPUnit test integration
- Performance-optimized stubs

### Vue

- Volar in hybrid mode for optimal performance
- TypeScript integration
- Vitest testing

### Web Development

- HTML/CSS/SCSS language servers
- Tailwind CSS integration
- JSON with schema validation

## Customization

This configuration is designed to be easily customizable:

### Adding New Plugins

1. Edit the appropriate file in `lua/thenameiswiiwin/plugins/` directory
2. Follow the Lazy.nvim format for adding plugins
3. Run `:Lazy sync` to install

### Changing Keymaps

Modify `lua/thenameiswiiwin/core/keymaps.lua` to add or change key mappings.

### Language Server Configuration

Modify language-specific settings in the `lua/thenameiswiiwin/plugins/lang/` directory.

### Performance Tuning

If you need to further optimize for performance:

- Disable unused language servers in the language configuration files
- Modify treesitter parsers to only include languages you use
- Adjust the large file thresholds in `lua/thenameiswiiwin/core/autocmds.lua`

## Troubleshooting

### Common Issues

#### Slow startup time

- Check which plugins are loading at startup with `:Lazy profile`
- Consider lazy-loading more plugins

#### LSP not working for a language

- Run `:Mason` and check if the language server is installed
- Check the language server logs with `:LspLog`

#### Completion not showing

- Make sure the LSP server is running (`:LspInfo`)
- Check if the completion source is available (`:lua require('cmp').setup.info()`)

#### Large file performance

- The configuration automatically disables heavy features for files > 1MB
- You can adjust this threshold in the autocmds.lua file

### Getting Help

- Check `:help` for Neovim documentation
- Look at plugin documentation in their respective GitHub repositories
- Check the Neovim subreddit or Discord for community help
