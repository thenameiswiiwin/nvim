return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      javascriptreact = { "prettierd", "prettier" },
      typescriptreact = { "prettierd", "prettier" },
      css = { "prettierd", "prettier" },
      html = { "prettierd", "prettier" },
      json = { "prettierd", "prettier" },
      yaml = { "prettierd", "prettier" },
      markdown = { "prettierd", "prettier" },
      graphql = { "prettierd", "prettier" },
      vue = { "prettierd", "prettier" },
      svelte = { "prettierd", "prettier" },
      sh = { "shfmt" },
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
    },
  },
}
