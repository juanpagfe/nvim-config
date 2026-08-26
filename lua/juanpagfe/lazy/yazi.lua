return {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",

    keys = {
        { "<leader>e", "<cmd>Yazi<cr>", desc = "Yazi" },
    },

    opts = {
        open_for_directories = false,
    },
}
