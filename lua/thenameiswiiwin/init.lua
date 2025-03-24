require("thenameiswiiwin.options")   -- Load Neovim options
require("thenameiswiiwin.keymaps")   -- Load key mappings
require("thenameiswiiwin.lazy_init") -- Initialize plugin manager

-- Create autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- Remove trailing whitespace on save
local format_group = augroup("FormatOnSave", {})
autocmd({ "BufWritePre" }, {
  group = format_group,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Reload configuration
function R(name)
  require("plenary.reload").reload_module(name)
end

-- Set up filetype detection for special files
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

-- LSP configuration
autocmd("LspAttach", {
  group = augroup("UserLspConfig", {}),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local opts = { buffer = event.buf }

    -- Key mappings available after LSP attaches
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>rf", vim.lsp.buf.references, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

    -- Auto format on save if supported
    if client and client.supports_method("textDocument/formatting") then
      autocmd("BufWritePre", {
        group = augroup("LspFormat." .. event.buf, {}),
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = event.buf,
            timeout_ms = 1000,
          })
        end,
      })
    end
  end,
})
