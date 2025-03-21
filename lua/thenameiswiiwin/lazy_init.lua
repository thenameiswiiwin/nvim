local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "thenameiswiiwin.plugins",
    change_detection = { notify = false },
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin",
                "tohtml", "tutor", "zipPlugin", "rplugin", "spellfile",
                "man", "shada", "health", "editorconfig",
            },
        },
    },
    install = { colorscheme = { "catppuccin", "habamax" } },
    ui = { border = "rounded" },
    checker = { enabled = true, notify = false },
})
