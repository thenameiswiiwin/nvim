-- Helper function for terminal window navigation
local function term_nav(direction)
  return function()
    if vim.fn.winnr("$") > 1 then
      return string.format("<cmd>wincmd %s<cr>", direction)
    else
      return ""
    end
  end
end

-- Better movement in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Cursor position after joining lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Keep cursor centered when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down with centered cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up with centered cursor" })

-- Keep search results centered
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Paste without losing register content
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Escape from insert mode
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- Disable ex mode
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- Quickfix navigation
vim.keymap.set("n", "<leader>xn", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>xp", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<CR>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>xl", "<cmd>lnext<CR>zz", { desc = "Next location item" })
vim.keymap.set("n", "<leader>xL", "<cmd>lprev<CR>zz", { desc = "Previous location item" })

-- Quick search and replace for word under cursor
vim.keymap.set(
  "n",
  "<leader>sr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace word under cursor" }
)

-- Make script executable
vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Reload config
vim.keymap.set("n", "<leader><leader>", "<cmd>source %<CR>", { desc = "Reload current file" })

-- Splits navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to right split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to split below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to split above" })

-- Terminal window navigation
vim.keymap.set("t", "<C-h>", term_nav("h"), { expr = true, desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", term_nav("j"), { expr = true, desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", term_nav("k"), { expr = true, desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", term_nav("l"), { expr = true, desc = "Go to Right Window" })

-- Diagnostic navigation
vim.keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- LSP keybindings (these will be applied on LSP attach)
vim.g.lsp_keymaps = {
  {
    "n",
    "gd",
    function()
      vim.lsp.buf.definition()
    end,
    { desc = "Go to definition" },
  },
  {
    "n",
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    { desc = "Show hover information" },
  },
  {
    "n",
    "<leader>vd",
    function()
      vim.diagnostic.open_float()
    end,
    { desc = "Open diagnostic float" },
  },
  {
    "n",
    "<leader>ca",
    function()
      vim.lsp.buf.code_action()
    end,
    { desc = "Code action" },
  },
  {
    "n",
    "<leader>cr",
    function()
      vim.lsp.buf.rename()
    end,
    { desc = "Rename symbol" },
  },
  {
    "n",
    "<leader>cf",
    function()
      vim.lsp.buf.references()
    end,
    { desc = "Find references" },
  },
  {
    "i",
    "<C-h>",
    function()
      vim.lsp.buf.signature_help()
    end,
    { desc = "Signature help" },
  },
}

-- Quick save
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- File explorer
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open file explorer" })

-- FZF-lua keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_workspace<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "Document symbols" })
