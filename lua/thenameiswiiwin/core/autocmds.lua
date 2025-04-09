local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    -- Use pcall to handle potential errors
    pcall(function()
      -- Try the newer API first
      if vim.highlight then
        vim.highlight.on_yank({
          higroup = "IncSearch",
          timeout = 40,
        })
      else
        -- Fallback to new API in Neovim 0.10+
        vim.hl.on_yank({
          higroup = "IncSearch",
          timeout = 40,
        })
      end
    end)
  end,
})

-- Remove trailing whitespace on save
local format_group = augroup("FormatOnSave", {})
autocmd({ "BufWritePre" }, {
  group = format_group,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

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

    -- Enable inlay hints if supported
    if client and client.supports_method("textDocument/inlayHint") then
      -- Using pcall to handle API differences across Neovim versions
      pcall(function()
        if vim.fn.has("nvim-0.10") == 1 then
          -- For Neovim 0.10+
          vim.lsp.inlay_hint.enable(true)
        else
          -- For older versions
          vim.lsp.inlay_hint.enable(event.buf, true)
        end
      end)
    end
  end,
})

-- Auto-format on save using conform.nvim
autocmd("BufWritePre", {
  group = augroup("FormatOnSave", {}),
  callback = function(args)
    -- Skip formatting if disabled
    if vim.b[args.buf].disable_autoformat or vim.g.disable_autoformat then
      return
    end

    local conform = require("conform")
    conform.format({ bufnr = args.buf, timeout_ms = 500 })
  end,
})

-- Auto-open file explorer when opening a directory
autocmd("BufEnter", {
  desc = "Open Oil when entering a directory",
  group = vim.api.nvim_create_augroup("oil-auto-open", { clear = true }),
  callback = function(args)
    -- Only attempt to use Oil if it's available
    if not pcall(require, "oil") then
      return
    end

    local path = vim.api.nvim_buf_get_name(args.buf)
    if vim.fn.isdirectory(path) == 1 then
      vim.cmd.Oil(path)
    end
  end,
})

-- Automatic buffer cleanup
autocmd("BufEnter", {
  callback = function()
    -- Auto close unmodified buffers after opening too many
    if #vim.fn.getbufinfo({ buflisted = 1 }) > 30 then
      local buffers_to_keep = {}
      -- Keep current and visible buffers
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        buffers_to_keep[vim.api.nvim_win_get_buf(win)] = true
      end
      -- Close others if unmodified
      for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
        if not buffers_to_keep[buf.bufnr] and buf.changed == 0 then
          vim.api.nvim_buf_delete(buf.bufnr, { force = false })
        end
      end
    end
  end,
  group = augroup("buffer_cleanup", { clear = true }),
})

-- Close some filetypes with just 'q'
autocmd("FileType", {
  pattern = {
    "help",
    "man",
    "qf",
    "oil",
    "lspinfo",
    "trouble",
    "spectre_panel",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set(
      "n",
      "q",
      "<cmd>close<cr>",
      { buffer = event.buf, silent = true }
    )
  end,
})

-- Auto-reload files when changed externally
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", {}),
  command = "checktime",
})

-- Limit treesitter for large files
autocmd("BufReadPre", {
  group = augroup("LargeFileOptimization", {}),
  callback = function(args)
    local max_filesize = 1024 * 1024 -- 1 MB
    local ok, stats =
      pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))

    if ok and stats and stats.size > max_filesize then
      -- Disable treesitter for large files
      vim.cmd("TSBufDisable highlight")

      -- Set manual folding instead of treesitter for large files
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.foldexpr = "0"

      -- Disable syntax highlighting for extremely large files
      if stats.size > max_filesize * 2 then
        vim.cmd("syntax off")
      end
    end
  end,
})

-- Disable automatic completion for large files
autocmd("BufReadPre", {
  group = augroup("DisableCompletionLargeFiles", {}),
  callback = function(args)
    local max_filesize = 1024 * 1024 -- 1 MB
    local ok, stats =
      pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))

    if ok and stats and stats.size > max_filesize then
      -- Disable nvim-cmp
      require("cmp").setup.buffer({ enabled = false })
    end
  end,
})
