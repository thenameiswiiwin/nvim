# Neovim Configuration

A modern Neovim setup optimized for web development with JavaScript/TypeScript, React/Next.js, Vue/Nuxt, TailwindCSS, and Laravel.

## Features

- 🚀 Fast startup with lazy-loading plugins
- 🎨 Modern UI with Catppuccin theme
- 📊 Smart LSP configuration for web development
- 🔧 Debugging support with nvim-dap
- 🧩 Code completion with nvim-cmp and GitHub Copilot
- 🔍 Fuzzy finding with Telescope
- 🌲 Syntax highlighting with Treesitter
- 🧪 Testing integration with Neotest
- 📂 File navigation with Oil.nvim
- 📝 Snippets support with LuaSnip

## Structure

```
nvim/
├── init.lua                 # Entry point
├── lua/
│   └── thenameiswiiwin/     # Personal namespace
│       ├── init.lua         # Main configuration loader
│       ├── set.lua          # Vim options
│       ├── remap.lua        # Key mappings
│       ├── lazy_init.lua    # Lazy plugin manager setup
│       └── lazy/            # Plugin configurations
│           ├── init.lua     # Core plugins
│           ├── lsp.lua      # LSP configuration
│           ├── colors.lua   # Theme configuration
│           ├── treesitter.lua  # Syntax highlighting
│           ├── telescope.lua   # Fuzzy finder
│           └── ...          # Other plugin configs
```

## Prerequisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- (Optional) Node.js and npm for LSP features
- (Optional) Go for Go development

## Installation

1. Backup your existing Neovim configuration:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone this repository:

```bash
git clone https://github.com/thenameiswiiwin/nvim.git ~/.config/nvim
```

3. Start Neovim:

```bash
nvim
```

The configuration will automatically:

- Install Lazy.nvim plugin manager
- Install all configured plugins
- Set up LSP servers via Mason

## Key Features and Plugins

### Plugin Management

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Modern plugin manager

### Theme and UI

- [Catppuccin](https://github.com/catppuccin/nvim) - Main colorscheme
- [Rose Pine](https://github.com/rose-pine/neovim) - Alternative colorscheme
- Custom statusline with express_line.nvim

### LSP (Language Server Protocol)

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Official LSP config
- [mason.nvim](https://github.com/williamboman/mason.nvim) - Package manager for LSP servers
- Configured for JavaScript, TypeScript, Vue, CSS, HTML, and more

### Completion & Snippets

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine
- [Copilot](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot integration

### Syntax & Highlighting

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting

### Navigation

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [harpoon](https://github.com/ThePrimeagen/harpoon) - File navigation
- [oil.nvim](https://github.com/stevearc/oil.nvim) - File explorer

### Git Integration

- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Git commands
- [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) - LazyGit integration

### Debugging

- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug Adapter Protocol client
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - UI for nvim-dap

### Testing

- [neotest](https://github.com/nvim-neotest/neotest) - Testing framework
- Configured for Go and other languages

### Formatting & Linting

- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) - Linter

### Other Utilities

- [mini.nvim](https://github.com/echasnovski/mini.nvim) - Collection of minimal plugins
- [trouble.nvim](https://github.com/folke/trouble.nvim) - Pretty diagnostics
- [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) - Distraction-free coding
- [undotree](https://github.com/mbbill/undotree) - Visualize undo history
- [cloak.nvim](https://github.com/laytan/cloak.nvim) - Hide sensitive information

## Key Mappings

This configuration uses Space as the leader key. Here are some important keybindings:

### General

- `<Space>` - Leader key
- `<leader><leader>` - Source current file
- `<leader>pv` - Open file explorer (Oil)
- `<leader>pp` - Toggle floating file explorer
- `<C-f>` - Open tmux sessionizer

### Navigation

- `<leader>pf` - Find files
- `<C-p>` - Find Git files
- `<leader>ps` - Search by grep
- `<C-h/t/n/s>` - Navigate to harpoon marks 1-4
- `<leader>a` - Add file to harpoon
- `<C-e>` - Toggle harpoon quick menu

### LSP

- `gd` - Go to definition
- `K` - Show hover documentation
- `<leader>vws` - Workspace symbol search
- `<leader>vd` - Show diagnostics
- `<leader>ca` - Code actions
- `<leader>vrr` - Show references
- `<leader>vrn` - Rename
- `[d` / `]d` - Next/previous diagnostic

### Git

- `<leader>gs` - Git status (Fugitive)
- `<leader>gg` - Open LazyGit

### Formatting & Editing

- `<leader>f` - Format file
- `<leader>l` - Run linter
- `<leader>s` - Search and replace word under cursor

### Testing & Debugging

- `<leader>tr` - Run nearest test
- `<leader>ts` - Run test suite
- `<leader>td` - Debug nearest test
- `<F8>` - Debug: Continue
- `<F10>` - Debug: Step Over
- `<F11>` - Debug: Step Into
- `<F12>` - Debug: Step Out
- `<leader>b` - Toggle breakpoint

### UI & Focus

- `<leader>zz` - Toggle Zen mode (with numbers)
- `<leader>zZ` - Toggle Zen mode (no numbers)
- `<leader>u` - Toggle UndoTree
- `<leader>tt` - Toggle Trouble diagnostics

## Optimization Suggestions

Based on your configuration, here are some suggestions for optimization:

1. **Plugin Consolidation**: You have multiple Git-related plugins (vim-fugitive, lazygit). Consider if you need both.

2. **LSP Configuration**: Your LSP setup is comprehensive but somewhat complex. Consider using [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) more extensively for automatic server setup.

3. **Color Theme Management**: You're loading both Rose Pine and Catppuccin. Consider choosing one as default and make the other optional.

4. **Key Mapping Organization**: Consider organizing your key mappings by category for better maintenance.

5. **Module Structure**: Your lazy/ directory has many files. Consider grouping related plugins into single files (e.g., git.lua for all Git plugins).

## Customization

You can customize this configuration by modifying the lua files in the `lua/thenameiswiiwin` directory:

- Edit `set.lua` for Vim options
- Edit `remap.lua` for key mappings
- Edit or add files in the `lazy/` directory for plugin configurations

## Troubleshooting

If you encounter issues:

1. Check the health of your Neovim installation:

   ```
   :checkhealth
   ```

2. Ensure all required dependencies are installed.

3. Update plugins:

   ```
   :Lazy update
   ```

4. Sync plugins:
   ```
   :Lazy sync
   ```
# nvim
