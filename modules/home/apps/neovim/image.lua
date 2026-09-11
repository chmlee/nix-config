require("image").setup({
    backend = "kitty",
    max_width_window_percentage = math.huge,
    max_height_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor = {
        background = "white",
        inline = { enable = true },
    },
})
