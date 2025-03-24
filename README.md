# Comprehensive Neovim Configuration Guide

This guide will walk you through all the features of your optimized Neovim configuration, explaining use cases, when to use each feature, and detailed explanations of all keymaps.

## Core Features and Their Use Cases

### 1. Catppuccin Mocha Theme

**Purpose**: Provides a pleasant, low-contrast dark theme with carefully selected colors that reduce eye strain during long coding sessions.

**When to use it**: This is your default colorscheme and is always active. It's particularly beneficial in low-light environments or for extended coding sessions.

**Features**:

- Semantic highlighting that helps distinguish different code elements
- Specially tuned for web development languages like JavaScript, TypeScript, HTML, and CSS
- Optimized contrast ratios for improved readability
- Integration with plugins like Telescope, Git signs, and LSP to ensure visual consistency

### 2. Oil.nvim File Explorer

**Purpose**: A minimal file explorer that lets you navigate and manipulate your file system without leaving the Neovim buffer system.

**When to use it**:

- When you need to browse directory structures
- When creating, renaming, moving, or deleting files
- When you want to perform file operations without opening a separate tool

**Features**:

- Uses buffer system for navigation, making it feel like a natural part of the editor
- Shows hidden files (toggle with `g.`)
- Configurable views and sorting
- Support for preview, split views, and file operations
- Automatically hides common directories you don't need to see (node_modules, .git, etc.)

### 3. Harpoon 2

**Purpose**: Provides lightning-fast navigation between your most frequently used files in a project.

**When to use it**:

- When working on related files across a project
- When you find yourself jumping between the same files repeatedly
- Perfect for feature development where you need to modify multiple files

**Features**:

- Marks files for quick access (up to 5 prioritized in this configuration)
- Persists marks between Neovim sessions
- Telescope integration for visual selection from marked files
- Supports navigation between marks with simple keystrokes

### 4. Minimal Statusline (Lualine)

**Purpose**: Provides essential information about your current buffer without being visually distracting.

**When to use it**: Always active, showing you contextual information based on what you're doing.

**Features**:

- Shows current file path, Git information, and diagnostics
- Adapts based on the mode you're in (normal, insert, visual)
- Automatically hides in certain buffers where it's not needed
- Integrates with plugins to show relevant status information
- Uses Catppuccin theme for visual consistency
- Displays LSP progress indicators in real-time

### 5. LSP (Language Server Protocol) Configuration

**Purpose**: Provides intelligent code assistance, including auto-completion, diagnostics, definition jumping, and more.

**When to use it**: Automatically activates when editing supported file types.

**Features**:

- Managed through Mason for easy installation and updates
- Configured for all your primary languages (JS/TS, PHP, CSS, HTML, Vue, etc.)
- Format on save with Conform.nvim
- Linting with nvim-lint
- Hover documentation
- Code actions (quick fixes)
- Navigation to definitions, references, and implementations
- Rename symbols across files
- Signature help when writing function calls
- Inlay Hints: Shows type information and parameter names directly in your code
- LSP Progress Indicator: Displays real-time feedback on LSP operations in your statusline
- Enhanced TypeScript Support: Specialized tools for TypeScript with deeper language understanding

### 6. GitHub Copilot Integration

**Purpose**: AI-powered code completion that suggests entire lines or blocks of code as you type.

**When to use it**: When writing new code or implementations where you could benefit from AI assistance.

**Features**:

- Auto-triggering with configurable keyboard shortcuts
- Accept line suggestions with `<C-CR>` (Ctrl+Enter)
- Accept word suggestions with `<M-k>` (Alt+k)
- Accept full suggestions with `<M-l>` (Alt+l)
- Works alongside traditional LSP completions
- Suggestions panel with `<M-CR>` (Alt+Enter)
- Ghost Text Preview: Shows completions directly in your code before accepting them

### 7. Testing Framework (Neotest)

**Purpose**: Run and debug tests directly from your editor.

**When to use it**:

- When writing tests for your code
- When debugging failing tests
- During test-driven development

**Features**:

- Support for multiple test frameworks (Jest, Vitest, PHPUnit, Playwright, etc.)
- Run individual tests or entire test suites
- Debug tests with DAP integration
- View test output in a floating window
- Jump between test failures

### 8. Git Integration

**Purpose**: Manage Git operations without leaving your editor.

**When to use it**:

- When tracking changes in your code
- When staging, committing, or resolving conflicts
- When reviewing changes before committing

**Features**:

- Git signs in the gutter showing line changes
- Blame information
- Interactive staging and unstaging
- Commit creation
- Conflict resolution helpers
- LazyGit integration for a full-featured Git UI

### 9. Zen Mode

**Purpose**: Reduces visual distractions to help you focus on your code.

**When to use it**:

- When you need deep focus
- When working on complex code that requires concentration
- When writing documentation or longer text sections

**Features**:

- Two modes: standard (with line numbers) and full focus
- Centers your code on the screen
- Hides UI elements you don't need while focusing
- Keybindings to toggle between normal and Zen modes

### 10. Indentation Guides

**Purpose**: Visual indicators that help you see code structure and nesting levels.

**When to use it**: Always active when editing code, particularly useful for deeply nested structures.

**Features**:

- Rainbow colors to distinguish different nesting levels
- Animated scope indication when moving between blocks
- Works well with all supported languages
- Subtle indicators that don't distract from the code

### 11. Telescope Fuzzy Finder

**Purpose**: Powerful search and selection interface for files, text, and more.

**When to use it**:

- When looking for files by name
- When searching for text across your project
- When selecting from lists (buffers, Git branches, etc.)

**Features**:

- Fast fuzzy finding with FZF integration
- File navigation
- Live grep for text search
- Preview capabilities
- Integration with LSP (symbols, references, etc.)
- Git integration for branches, commits, and status

### 12. Treesitter

**Purpose**: Advanced syntax highlighting and code navigation based on an understanding of language structure.

**When to use it**: Automatically active for all supported languages.

**Features**:

- Smarter syntax highlighting
- Code folding based on language structure
- Text objects for structural navigation
- Incremental selection based on syntax nodes
- Language-aware indentation
- Support for all your primary languages
- Smart Code Folding: Intelligent code folding based on language structure
- Rainbow Delimiters: Color-coded matching brackets and braces for easier visualization
- Advanced Refactoring: Enhanced tools for renaming, navigation, and code transformation
- Treesitter Playground: Debugging tool for examining syntax tree and language queries

### 13. Completion System (nvim-cmp)

**Purpose**: Intelligent code completion from multiple sources.

**When to use it**: Automatically triggered while typing or manually activated.

**Features**:

- LSP-based completions
- Snippet integration
- Copilot integration
- Path completions
- Buffer text completions
- Customizable sorting and filtering
- Icons and documentation display
- Additional Completion Sources: Emoji, calculations, and Neovim Lua API
- Ghost Text Preview: Shows completions directly in the editor before accepting

### 14. Debug Adapter Protocol (DAP)

**Purpose**: Provides debugging capabilities directly in your editor.

**When to use it**:

- When debugging applications
- When you need to set breakpoints and step through code
- When inspecting variables during execution

**Features**:

- Integration with multiple debugging protocols
- Breakpoint management
- Variable inspection
- Step-by-step execution
- Call stack examination
- UI for debug state

## Detailed Keymap Explanations

### Navigation and General Usage

#### File Navigation

- `<leader>pv` (Open Oil explorer): Opens the parent directory in Oil file explorer. Use this when you need to browse files in your project directory, create new files, or manipulate the file system.

- `<leader>ff` (Find files): Opens Telescope file finder. Use this when you know the name (or part of the name) of a file you want to open, especially in large projects with many files.

- `<leader>fg` (Live grep): Searches for text across your entire project. Use this when you need to find all occurrences of a particular string, function name, or variable across your codebase.

- `<leader>fb` (Buffers): Shows all open buffers for quick switching. Use this to navigate between files you've already opened in your current session.

- `<C-d>` / `<C-u>` (Scroll half-page down/up): Navigates vertically within a file while keeping your cursor centered. Use these for quickly scanning through longer files without losing context.

#### Harpoon Navigation

- `<leader>ha` (Add file to Harpoon): Marks the current file for quick access later. Use this when you're working on a file that you know you'll need to return to frequently.

- `<leader>hm` (Harpoon menu): Opens a menu showing all marked files. Use this when you want to see a list of all your marked files and choose one to open.

- `<leader>1-5` (Jump to Harpoon files): Instantly jumps to the corresponding marked file. Use these shortcuts when you know exactly which marked file you want to open (1st, 2nd, etc.).

- `<leader>hn` / `<leader>hp` (Next/previous Harpoon file): Cycles through your marked files. Use these when you're iterating through your set of important files.

#### Split Management

- `<C-h/j/k/l>` (Navigate splits): Moves between split panes without using the mouse. Use these when working with multiple files side by side.

### Code Editing and Manipulation

#### Selection and Movement

- `J` / `K` in visual mode: Moves selected lines down/up. Use these when rearranging blocks of code or reorganizing lines.

- `J` in normal mode: Joins the current line with the line below while preserving cursor position. Use this when combining lines or reformatting code.

- `n` / `N`: Navigates search results while keeping them centered. Use these after performing a search to keep context while moving through matches.

#### Clipboard Operations

- `<leader>y` / `<leader>Y`: Yanks (copies) text to system clipboard. Use these when you need to copy code for pasting outside of Neovim.

- `<leader>p` in visual mode: Pastes text without losing register contents. Use this when you want to replace selected text without overwriting what's in your paste buffer.

- `<leader>d`: Deletes text without yanking. Use this when you want to delete text without affecting your clipboard/registers.

#### Text Manipulation

- `<leader>s`: Quick search and replace for the word under cursor. Use this for refactoring variable names or changing specific terms throughout a file.

- `<leader>x`: Makes the current file executable. Use this for shell scripts or other executable files that need the execute permission.

- `<leader>ee`: Inserts error handling snippet for Go. Use this when writing Go code that returns errors.

- `<leader>el`: Inserts error logging snippet. Use this when you need to add error logging to your code.

### Quickfix Navigation

- `<leader>qn` / `<leader>qp`: Navigate to next/previous item in the quickfix list. Use these to move through compilation errors, search results, or other items in the quickfix list.

- `<leader>k` / `<leader>j`: Navigate to next/previous item in the location list. Use these for localized lists of diagnostics or search results.

### LSP Features

#### Code Navigation

- `gd` (Go to definition): Jumps to where a symbol is defined. Use this when you need to understand how a function, variable, or type is implemented.

- `<leader>rf` (Find references): Shows all places where a symbol is used. Use this when refactoring to see all the places you need to update.

- `K` (Hover information): Shows documentation for the symbol under cursor. Use this to quickly check function signatures, type information, or documentation without leaving your current position.

- `<leader>th` (Toggle inlay hints): Toggles type hints and parameter names inline in your code. Use this when you want additional context about types without hovering.

#### Code Actions

- `<leader>ca` (Code actions): Shows available actions for fixing or modifying code. Use this when you see an error or warning and want to see automatic fix options.

- `<leader>rn` (Rename): Renames a symbol across your project. Use this for refactoring variable, function, or class names.

- `<leader>vd` (View diagnostic): Shows detailed information about the current diagnostic. Use this when you need more context about an error or warning.

#### Diagnostics Navigation

- `[d` / `]d`: Navigate to previous/next diagnostic in the file. Use these to quickly move between errors and warnings in your code.

- `<leader>dd`: Opens floating window with diagnostic details. Use this when you need to see the full text of a diagnostic message.

### Git Operations

#### Fugitive Commands (Prefix: `<leader>gf`)

- `<leader>gfs` (Fugitive: Git status): Opens Fugitive for Git status view. Use this to see all changes in your repository and stage/unstage files.

- `<leader>gfc` (Fugitive: Git commit): Initiates a commit through Fugitive. Use this when you're ready to commit your staged changes.

- `<leader>gfp` (Fugitive: Git push): Pushes your changes to the remote repository. Use this after committing to share your changes.

- `<leader>gfl` (Fugitive: Git pull): Pulls changes from the remote repository with rebase. Use this to keep your local repository up to date.

- `<leader>gfb` (Fugitive: Git blame): Shows blame information for the current file. Use this to see who last modified each line of code.

#### LazyGit

- `<leader>gg` (LazyGit): Opens the LazyGit interface. Use this for a comprehensive Git UI when performing complex Git operations.

#### Gitsigns Navigation and Actions

- `]g` / `[g`: Navigate to next/previous Git hunk (changed section). Use these to review changes in your code.

- `<leader>hs` / `<leader>hr`: Stage/reset Git hunk. Use these to selectively stage or unstage changes within a file.

- `<leader>hb`: Show blame information for current line. Use this to see who last changed a particular line of code and in which commit.

### Testing

- `<leader>tt` (Test nearest): Runs the test closest to your cursor. Use this during test-driven development to quickly verify a specific test.

- `<leader>tf` (Test file): Runs all tests in the current file. Use this when you've made changes that affect multiple tests in the same file.

- `<leader>ts` (Test suite): Runs the entire test suite. Use this before committing to ensure all tests pass.

- `<leader>td` (Debug test): Runs the nearest test with the debugger attached. Use this when a test is failing and you need to step through it to understand why.

- `<leader>to` (Test output): Shows the output of the last test run. Use this to see detailed test results, especially for failing tests.

### Debugging

- `<leader>dc` (Debug continue): Starts or continues debugging. Use this to begin a debugging session or to continue execution after stopping.

- `<leader>db` (Debug breakpoint): Toggles a breakpoint at the current line. Use this to mark where you want execution to pause during debugging.

- `<leader>dB` (Conditional breakpoint): Sets a conditional breakpoint. Use this when you only want to pause execution when certain conditions are met.

- `<leader>dn` / `<leader>di` / `<leader>do`: Step over/into/out during debugging. Use these to control execution flow while debugging.

- `<leader>du` (Debug UI): Toggles the debugging UI. Use this to see variables, call stack, and other debug information.

### Focus and Distraction Management

- `<leader>zz` (Zen mode with line numbers): Toggles a focused mode that hides UI elements but keeps line numbers. Use this when you want to concentrate but still need line references.

- `<leader>zZ` (Full Zen mode): Toggles a completely distraction-free mode. Use this when you need maximum focus and don't need line numbers.

### Treesitter Text Object and Navigation

- `<leader>ws` / `<leader>wS`: Swap next/previous parameter. Use these to quickly reorganize function parameters.

- `<leader>wf` / `<leader>wF`: Swap next/previous function. Use these to rearrange function declarations.

- `<leader>wm` / `<leader>wM`: Swap next/previous method call. Use these to reorganize method chains.

- `<leader>tr` (Smart rename): Performs a treesitter-aware rename of the symbol under cursor, respecting the language semantics. Use this for more accurate renaming.

- `gnd` (Go to definition): Uses treesitter to jump to the definition of a symbol. Useful when LSP is not available.

- `gnD` (List definitions): Shows all definitions of the current symbol in the project.

- `gO` (List definitions TOC): Displays a table of contents of all definitions in the current file.

- `<a-*>` / `<a-#>` (Next/previous usage): Navigates between usages of the current symbol. Useful for reviewing how a function or variable is used.

### Folding

- `zR` (Open all folds): Expands all code folds in the current buffer. Use this to see the entire file.

- `zM` (Close all folds): Collapses all code sections. Use this for getting an overview of the file structure.

- `zr` (Open folds except kinds): Selectively opens folds. Useful when you want to focus on specific types of code blocks.

### Additional Utilities

- `<leader>u` (Undotree): Opens the undo history visualizer. Use this when you need to navigate through complex edit history.

- `<leader><leader>` (Source): Reloads the current file. Use this after making changes to your Neovim configuration to apply them without restarting.

- `<C-s>` (Save): Quickly saves the current file. Use this periodically to save your work.

- `<leader>xx` (Trouble document diagnostics): Opens the Trouble panel with current file diagnostics. Use this to get an overview of all issues in your file.

- `<leader>xX` (Trouble workspace diagnostics): Opens the Trouble panel with project-wide diagnostics. Use this to see all issues across your project.

- `<leader>ts` (Toggle TS Playground): Opens the Treesitter Playground for debugging syntax trees and queries.

## Advanced Usage Scenarios

### Web Development Workflow

1. Start by opening your project with `nvim` in the terminal
2. Use `<leader>pv` to browse files or `<leader>ff` to find specific files
3. Mark important files (e.g., component, styles, tests) with Harpoon (`<leader>ha`)
4. When coding, use LSP features for auto-completion and diagnostics
5. Use `<leader>s` for quick refactoring of variable or function names
6. Run tests with `<leader>tt` or `<leader>tf` to verify changes
7. Use Git integration (`<leader>gg` or `<leader>gfs`) to stage and commit changes
8. Navigate back to other files using Harpoon shortcuts (`<leader>1-5`)

### TypeScript Development with Enhanced Features

1. Navigate to your TypeScript project
2. Use `<leader>ff` to find a specific file
3. While coding, notice inlay hints showing parameter names and return types
4. Use `<leader>th` to toggle these hints if they become distracting
5. When refactoring, use `<leader>tr` for smart renaming across the codebase
6. Navigate between usages with `<a-*>` and `<a-#>`
7. Use the ghost text preview for faster completion with Copilot
8. When facing complex nested code, rely on rainbow delimiters to visually match brackets
9. For a cleaner view, use `zM` to collapse all functions and `zR` to expand again

### Debugging Workflow

1. Set breakpoints in your code with `<leader>db`
2. Start debugging with `<leader>dc`
3. Step through code with `<leader>dn`, `<leader>di`, and `<leader>do`
4. Inspect variables and state in the debug UI (`<leader>du`)
5. Continue execution with `<leader>dc` until the next breakpoint
6. Fix issues and save with `<C-s>`
7. Restart debugging session to verify fixes

### Documentation Writing

1. Open the file you want to document
2. Enter Zen mode with `<leader>zZ` for distraction-free writing
3. Use LSP features for code snippets and documentation standards
4. When done, exit Zen mode and save your changes
5. Run tests if available to ensure documentation examples work

### Pair Programming

1. Use clear file navigation with Telescope and Oil to show your partner the codebase
2. Use `K` to show documentation and context for unfamiliar code
3. Use Git blame with `<leader>hb` to understand code history
4. Run tests together to verify changes
5. Use the minimal UI to maximize code visibility on shared screens

By understanding these features and keymaps, you'll be able to create an efficient and productive development workflow that leverages the full power of your Neovim configuration.
