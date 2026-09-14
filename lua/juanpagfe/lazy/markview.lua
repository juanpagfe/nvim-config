return {
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        config = function()
            local markview = require("markview")

            markview.setup({
                preview = {
                    filetypes = { "markdown", "quarto", "rmd" },
                    modes = { "n", "no", "c" },
                    hybrid_modes = { "n" },
                    callbacks = {
                        on_enable = function(_, win)
                            vim.wo[win].conceallevel = 2
                            vim.wo[win].concealcursor = "nc"
                        end,
                    },
                },
            })

            -- Toggle markview preview with <leader>mp
            vim.keymap.set("n", "<leader>mp", "<cmd>Markview toggle<CR>",
                { desc = "Toggle Markview preview" })
        end,
    },
}
