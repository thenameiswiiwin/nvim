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

    -- Apply predefined LSP keymaps
    for _, mapping in ipairs(vim.g.lsp_keymaps) do
      local mode, lhs, rhs, map_opts = unpack(mapping)
      map_opts = vim.tbl_extend("force", map_opts or {}, opts)
      vim.keymap.set(mode, lhs, rhs, map_opts)
    end

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
