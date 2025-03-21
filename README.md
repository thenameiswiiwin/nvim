# Neovim Configuration

A modern Neovim setup optimized for web development with JavaScript/TypeScript, React/Vue, Go, and more. This configuration focuses on performance, clean design, and developer productivity.

## Features

- 🚀 Fast startup with optimized lazy-loading
- 🎨 Clean UI with Catppuccin theme
- 📊 Intelligent LSP setup for multiple languages
- 🔧 Integrated debugging with nvim-dap
- 🧩 Powerful code completion (nvim-cmp + Copilot)
- 🔍 Fast fuzzy finding with Telescope
- 🌲 Syntax highlighting via Treesitter
- 🧪 Testing framework with Neotest
- 📂 Modern file navigation (Oil.nvim + Harpoon)
- 📝 Snippet support with LuaSnip

## Structure

```
nvim/
├── init.lua                 # Entry point
├── lua/
│   └── thenameiswiiwin/     # Personal namespace
│       ├── init.lua         # Main configuration loader
│       ├── set.lua          # Vim options
│       ├── remap.lua        # Core key mappings
│       ├── lazy_init.lua    # Lazy plugin manager setup
│       └── lazy/            # Plugin configurations
│           ├── init.lua     # Core plugins
│           ├── lsp.lua      # LSP configuration
│           ├── colors.lua   # Theme configuration
│           ├── treesitter.lua  # Syntax highlighting
│           └── ...          # Other plugin configs
```

## Prerequisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) installed and configured in your terminal
- Node.js and npm (optional, for LSP features)
- Go (optional, for Go development)
- Ripgrep (for Telescope grep functionality)

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

## Key Plugins

### Core

- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Modern plugin manager
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - Lua functions library

### UI and Aesthetics

- **[catppuccin](https://github.com/catppuccin/nvim)** - Main colorscheme
- **[express_line.nvim](https://github.com/tjdevries/express_line.nvim)** - Custom statusline

### Editor Enhancement

- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Advanced syntax highlighting
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder
- **[oil.nvim](https://github.com/stevearc/oil.nvim)** - File explorer in buffer
- **[harpoon](https://github.com/ThePrimeagen/harpoon)** - File navigation marks
- **[undotree](https://github.com/mbbill/undotree)** - Visualization of undo history
- **[trouble.nvim](https://github.com/folke/trouble.nvim)** - Diagnostics list
- **[zen-mode.nvim](https://github.com/folke/zen-mode.nvim)** - Distraction-free coding

### LSP and Completion

- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP configuration
- **[mason.nvim](https://github.com/williamboman/mason.nvim)** - Package manager for LSP
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** - Formatter
- **[nvim-lint](https://github.com/mfussenegger/nvim-lint)** - Linter
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Completion engine
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** - Snippet engine
- **[copilot.lua](https://github.com/zbirenbaum/copilot.lua)** - GitHub Copilot integration

### Git

- **[vim-fugitive](https://github.com/tpope/vim-fugitive)** - Git integration
- **[lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)** - LazyGit terminal UI

### Debugging and Testing

- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)** - Debug Adapter Protocol
- **[nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)** - UI for debugging
- **[neotest](https://github.com/nvim-neotest/neotest)** - Testing framework

### Utilities

- **[mini.nvim](https://github.com/echasnovski/mini.nvim)** - Collection of minimal plugins
- **[cloak.nvim](https://github.com/laytan/cloak.nvim)** - Hide sensitive information

## Key Mappings

This configuration uses Space as the leader key. Here are the most important keybindings:

### Navigation

- `<leader>pv` - Open file explorer (Oil)
- `<leader>pf` - Find files with Telescope
- `<C-p>` - Find Git files
- `<leader>ps` - Search by grep
- `<leader>a` - Add file to Harpoon
- `<C-e>` - Toggle Harpoon menu
- `<C-h/t/n/s>` - Jump to Harpoon marks 1-4

### LSP

- `gd` - Go to definition
- `K` - Show hover documentation
- `<leader>vd` - Show diagnostics
- `<leader>ca` - Code actions
- `<leader>vrr` - Show references
- `<leader>vrn` - Rename symbol
- `<leader>f` - Format file/selection

### Git

- `<leader>gs` - Git status (Fugitive)
- `<leader>gg` - Open LazyGit

### Editing

- `<leader>s` - Search and replace word under cursor
- `J/K` (visual mode) - Move selection up/down
- `<leader>y` - Yank to system clipboard
- `<leader>d` - Delete without yanking

### Debugging

- `<leader>b` - Toggle breakpoint
- `<F8>` - Continue
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out

### Testing

- `<leader>tr` - Run nearest test
- `<leader>ts` - Run test suite
- `<leader>td` - Debug nearest test

### UI

- `<leader>zz` - Toggle Zen mode (with numbers)
- `<leader>zZ` - Toggle Zen mode (no numbers)
- `<leader>u` - Toggle Undotree
- `<leader>tt` - Toggle Trouble panel

## Language Support

This configuration provides rich support for:

- **JavaScript/TypeScript**
- **React/Vue**
- **HTML/CSS**
- **Go**
- **Lua**
- **PHP**
- **Rust**
- **Markdown**

Each language has appropriate LSP servers, formatters, and linters configured.

## Customization

### Adding New Plugins

Add new plugins in the `lua/thenameiswiiwin/lazy/` directory:

```lua
-- Example: lua/thenameiswiiwin/lazy/newplugin.lua
return {
  "username/plugin-name",
  lazy = true, -- Load on demand
  event = "VeryLazy", -- Or specific events
  config = function()
    require("plugin-name").setup({
      -- Your configuration
    })
  end,
}
```

### Changing Theme

Modify the `colors.lua` file to change the default theme:

```lua
function ColorMyPencils(color)
  color = color or "your-theme-name" -- Change this
  vim.cmd.colorscheme(color)
  -- Additional customization
end
```

### Adding LSP Servers

Add new LSP servers in the `lsp.lua` file:

```lua
-- In the ensure_installed list:
require("mason-lspconfig").setup({
  ensure_installed = {
    "existing_servers",
    "your_new_server",
  },
  -- ...
})

-- Add server-specific configuration in handlers
["your_new_server"] = function()
  lspconfig.your_new_server.setup({
    capabilities = capabilities,
    -- Server-specific settings
  })
end,
```

## Performance Optimizations

This configuration includes several optimizations:

1. **Lazy Loading** - Most plugins only load when needed
2. **Efficient Plugin Choices** - Carefully selected for performance
3. **Treesitter Optimizations** - Large file detection
4. **Minimal UI** - Clean interface without unnecessary elements
5. **Strategic Autocommands** - Used sparingly to avoid overhead

## Troubleshooting

### Common Issues

1. **LSP servers not working**

   - Run `:Mason` and check if servers are installed
   - Run `:checkhealth` for diagnostic information

2. **Missing icons**

   - Ensure you have a Nerd Font installed and configured

3. **Slow startup**

   - Run `:Lazy profile` to identify slow plugins
   - Consider disabling heavy plugins you don't use

4. **Plugin errors**
   - Update plugins with `:Lazy update`
   - Sync plugins with `:Lazy sync`

### Commands for Debugging

- `:checkhealth` - Check Neovim health
- `:Lazy profile` - Profile plugin loading time
- `:LspInfo` - Show LSP information
- `:TSInstallInfo` - Show Treesitter parser status

## Updates and Maintenance

1. Update plugins regularly:

```vim
:Lazy update
```

2. Check for Neovim updates:

```bash
# If installed via package manager
sudo apt update && sudo apt upgrade neovim

# If installed via appimage/tarball, download the latest version
```

3. Update Treesitter parsers:

```vim
:TSUpdate
```

## Credits

This configuration draws inspiration from:

- [ThePrimeagen](https://github.com/ThePrimeagen)
- [TJ DeVries](https://github.com/tjdevries)
- [Catppuccin theme](https://github.com/catppuccin/nvim)

---

Feel free to fork and customize this configuration to match your preferences. For issues or suggestions, please open an issue on the GitHub repository.
