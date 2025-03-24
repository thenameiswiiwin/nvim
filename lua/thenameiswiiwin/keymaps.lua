-- Leader key (already set in options.lua, but including it here for clarity)
vim.g.mapleader = " "

-- Better movement in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Cursor position after joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor centered when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-b>", "<C-u>zz")

-- Keep search results centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without losing register content
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Escape from insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable ex mode
vim.keymap.set("n", "Q", "<nop>")

-- Quickfix navigation
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz", { desc = "Next location item" })
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz", { desc = "Previous quickfix item" })

-- Quick search and replace for word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make script executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Quick error handling snippets for various languages
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>Olog.Error("error", err)<Esc>')

-- Reload config
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- Splits navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to right split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to split below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to split above" })

-- Diagnostic navigation (in addition to those set in LSP attach)
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", { desc = "List diagnostics" })

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "References" })
vim.keymap.set("n", "<leader>fi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Implementations" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })

-- LSP keybindings (these will be applied on LSP attach)
vim.g.lsp_keymaps = {
  { "n", "gd",         vim.lsp.buf.definition,     { desc = "Go to definition" } },
  { "n", "K",          vim.lsp.buf.hover,          { desc = "Show hover information" } },
  { "n", "<leader>vd", vim.diagnostic.open_float,  { desc = "Open diagnostic float" } },
  { "n", "<leader>ca", vim.lsp.buf.code_action,    { desc = "Code action" } },
  { "n", "<leader>rn", vim.lsp.buf.rename,         { desc = "Rename symbol" } },
  { "n", "<leader>rf", vim.lsp.buf.references,     { desc = "Find references" } },
  { "i", "<C-h>",      vim.lsp.buf.signature_help, { desc = "Signature help" } },
  { "n", "[d",         vim.diagnostic.goto_prev,   { desc = "Previous diagnostic" } },
  { "n", "]d",         vim.diagnostic.goto_next,   { desc = "Next diagnostic" } },
}

-- Quick save
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
