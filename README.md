# Blazingly Fast Neovim Configuration

A minimal, blazingly fast Neovim configuration optimized for web development with ReactJS/NextJS, VueJS/NuxtJS, TailwindCSS, and Laravel, with comprehensive testing support.

## Features

- ⚡ **Blazingly Fast**: Optimized for speed with lazy-loading and minimal overhead
- 🎨 **Modern UI**: Clean interface with Catppuccin theme and carefully selected UI enhancements
- 🔍 **Intelligent LSP**: Comprehensive LSP setup for JavaScript, TypeScript, Vue, PHP, and more
- 🧩 **Smart Completion**: Context-aware code completion with snippets and AI assistance
- 🔄 **Built-in Testing**: Integrated testing with Neotest and adapters for Jest, Vitest, and PHPUnit
- 🚀 **Efficient Workflow**: Optimized for productivity with smart keymaps and commands
- 🛠️ **Framework Ready**: Specialized support for React, Vue, TailwindCSS, and Laravel
- 🧰 **Git Integration**: Comprehensive Git workflow with Gitsigns and LazyGit

## Prerequisites

- Neovim >= 0.9.0
- Git
- Node.js (for LSP servers)
- A Nerd Font (for icons)
- Ripgrep (for Telescope)

## Installation

1. Backup your existing Neovim configuration
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository
   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

3. Start Neovim
   ```bash
   nvim
   ```

   On first launch, plugins will be automatically installed.

## Structure

```
nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── core/                   # Core configuration
│   │   ├── init.lua            # Core initialization
│   │   ├── options.lua         # Vim options
│   │   ├── keymaps.lua         # Key mappings
│   │   ├── autocmds.lua        # Autocommands
│   │   └── lazy.lua            # Plugin manager setup
│   └── plugins/                # Plugin configurations
│       ├── init.lua            # Plugin initialization
│       ├── ui.lua              # UI-related plugins
│       ├── editor.lua          # Editor plugins
│       ├── lsp.lua             # LSP configurations
│       ├── completion.lua      # Completion setup
│       ├── treesitter.lua      # Syntax highlighting
│       ├── git.lua             # Git integration
│       ├── test.lua            # Testing configuration
│       ├── web.lua             # Web development (React, Vue)
│       └── php.lua             # PHP/Laravel support
└── README.md                   # Documentation
```

## Core Features

### File Navigation

- **Oil.nvim**: Browse files in a buffer with `<leader>e`
- **Telescope**: Fuzzy finder for files, buffers, and more with `<leader>f`
- **Harpoon**: Quick navigation between project files with `<leader>h`

### Code Editing

- **LSP**: Full LSP integration with auto-setup and smart mappings
- **Treesitter**: Advanced syntax highlighting and code navigation
- **Formatter**: Built-in formatting with conform.nvim
- **Linting**: Automatic linting with nvim-lint
- **Snippets**: Extensive snippet support with LuaSnip

### IDE-like Features

- **Testing**: Integrated testing framework with Neotest
- **Completion**: Smart completion with nvim-cmp
- **Debugging**: Debug support for multiple languages
- **AI Assistance**: GitHub Copilot integration for AI-powered suggestions

### Web Development

- **React/Next.js**: Enhanced support for React/Next.js development
- **Vue/Nuxt.js**: Specialized Vue/Nuxt.js tools and LSP setup
- **TailwindCSS**: Full TailwindCSS support with autocompletion and color preview
- **TypeScript**: Optimized TypeScript experience with typescript-tools.nvim

### PHP/Laravel Development

- **Laravel.nvim**: Laravel-specific functions and commands
- **Blade**: Enhanced support for Blade templates
- **PHPActor**: Advanced PHP refactoring tools
- **Intelephense**: Powerful PHP language server

## Key Mappings

This configuration uses space as the leader key. Here are the most important keymappings:

### General

- `<leader>w`: Save file
- `<leader>q`: Quit
- `<leader>h`: Clear highlights
- `jk`: Exit insert mode

### Navigation

- `<leader>e`: Open file explorer (Oil)
- `<leader>ff`: Find files
- `<leader>fg`: Live grep
- `<leader>fb`: Browse buffers
- `<S-h/l>`: Previous/next buffer
- `<C-h/j/k/l>`: Navigate splits

### LSP

- `gd`: Go to definition
- `gr`: Find references
- `K`: Show hover documentation
- `<leader>la`: Code actions
- `<leader>lr`: Rename symbol
- `<leader>lf`: Format file
- `<leader>le`: Show diagnostics
- `[d/]d`: Previous/next diagnostic

### Git

- `<leader>gg`: Open LazyGit
- `<leader>gj/k`: Next/previous hunk
- `<leader>gs`: Stage hunk
- `<leader>gr`: Reset hunk
- `<leader>gl`: Blame line

### Testing

- `<leader>tt`: Run nearest test
- `<leader>tf`: Run file tests
- `<leader>ts`: Toggle test summary
- `<leader>to`: Open test output

### Laravel

- `<leader>la`: Laravel Artisan
- `<leader>lr`: Laravel Routes
- `<leader>lm`: Laravel Migrate

## Language Servers

This configuration automatically installs and configures LSP servers for:

- TypeScript/JavaScript (tsserver)
- Vue (volar)
- HTML/CSS
- TailwindCSS
- PHP (intelephense)
- Lua
- JSON/YAML
- Markdown
- And more...

## Customization

### Adding new plugins

Add new plugins by creating or modifying files in the `lua/plugins/` directory. Plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

Example:
```lua
-- lua/plugins/myplugin.lua
return {
  "username/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- Your configuration here
    })
  end,
}
```

### Changing theme

The default theme is Catppuccin Mocha. To change it, modify the `lua/plugins/ui.lua` file:

```lua
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  opts = {
    flavour = "macchiato", -- Change to "latte", "frappe", "macchiato", or "mocha"
    -- Rest of the configuration...
  },
}
```

### Adding keymaps

Add new keymaps in `lua/core/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>key", function()
  -- Your function here
end, { desc = "Description" })
```

## Performance Optimization

This configuration includes several optimizations for performance:

1. **Lazy Loading**: Most plugins only load when needed
2. **Fast Plugin Manager**: Using lazy.nvim for efficient plugin management
3. **Minimal Core**: Only essential options and mappings loaded at startup
4. **Optimized Dependencies**: Careful selection of lightweight dependencies
5. **Treesitter Optimizations**: Disabling for large files
6. **Strategic Event Registration**: Using appropriate events for plugin loading

## Troubleshooting

If you encounter issues:

1. Update plugins: `:Lazy update`
2. Check health: `:checkhealth`
3. Ensure all dependencies are installed
4. Check LSP status: `:LspInfo`
5. Verify treesitter parsers: `:TSInstallInfo`

## Credits

This configuration is inspired by best practices from various Neovim configurations and optimized for web development workflows.
