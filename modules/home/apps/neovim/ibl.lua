require("ibl").setup {
  indent = {
    char = "",
    highlight = "IblIndent",
  }
}
--│, ┆, ⋅, ╎

-- Use very subtle color
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3a3a3a" })
