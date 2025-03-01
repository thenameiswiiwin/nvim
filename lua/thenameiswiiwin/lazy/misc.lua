return {
    {
        {
            "ThePrimeagen/cockpit",
            config = function()
                require("cockpit")
                vim.keymap.set("n", "<leader>ct", "<cmd>CockpitTest<CR>")
                vim.keymap.set("n", "<leader>cr", "<cmd>CockpitRefresh<CR>")
            end,
        },
        {
            "ThePrimeagen/caleb",
            config = function() end
        },
        {
            "ThePrimeagen/vim-apm",
            config = function()
                --[[
            local apm = require("vim-apm")

            apm:setup({})
            vim.keymap.set("n", "<leader>apm", function() apm:toggle_monitor() end)
            --]]
            end
        },
        {
            "ThePrimeagen/vim-with-me",
            config = function() end
        },
    }
}
