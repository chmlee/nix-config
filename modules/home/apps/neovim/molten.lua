vim.g.molten_auto_open_output = false
vim.g.molten_wrap_output = true
vim.g.molten_output_show_exec_time = true
vim.g.molten_output_win_hide_on_leave = false
vim.g.molten_use_border_highlights = true
vim.g.molten_virt_text_output = true
-- vim.g.molten_image_provider = "image.nvim"
-- vim.g.molten_image_location = "both"
vim.g.molten_output_virt_lines = true
vim.g.molten_cover_empty_lines = true
vim.g.molten_output_truncate = "bottom"
vim.g.molten_virt_text_max_lines = 20
--vim.g.molten_output = "pane"

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e2e" })
-- vim.api.nvim_set_hl(0, "MoltenVirtualText", {
--     bg = "#ae0606",
--     fg = "#ffd787",
--     italic = true,
-- })
vim.api.nvim_set_hl(0, "MoltenVirtualText", { bg = "#585b70", fg = "#f5e0dc", bold = true })

require("image").setup({
    editor = {
        -- force a visible background for plots
        background = "white", -- or "#ffffff" or "black"
        inline = {
            enable = true,
        },
    },
})

vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
    { silent = true, desc = "Initialize the plugin" })
vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
    { silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>",
    { silent = true, desc = "evaluate line" })
vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
    { silent = true, desc = "re-evaluate cell" })
vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
    { silent = true, desc = "evaluate visual selection" })
vim.keymap.set("n", "<localleader>rd", ":MoltenDelete<CR>",
    { silent = true, desc = "molten delete cell" })
vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>",
    { silent = true, desc = "hide output" })
vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>",
    { silent = true, desc = "show/enter output" })
