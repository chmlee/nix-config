local quarto = require('quarto')
require('quarto').setup {
  debug = true,
  lspFeatures = {
    enabled = true,
    hover = true,
    chunks = "auto",
    languages = { "r", "python", "julia", "bash", "html" },
    diagnostics = {
      enabled = false,
      lint_cache = false,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
    enabled = true,
    default_method = "molten",                                           -- "molten", "slime", "iron" or <function>
    ft_runners = { r = "molten", python = "molten", quarto = "molten" }, -- filetype to runner, ie. `{ python = "molten" }`.
    -- Takes precedence over `default_method`
    never_run = { 'yaml' },                                              -- filetypes which are never sent to a code runner
  },
}

vim.keymap.set('n', '<leader>qp', quarto.quartoPreview, { silent = true, noremap = true })

local runner = require("quarto.runner")
vim.keymap.set("n", "<localleader>rr", runner.run_cell, { desc = "run cell", silent = true })
vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
vim.keymap.set("n", "<localleader>rR", runner.run_all, { desc = "run all cells", silent = true })
vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
vim.keymap.set("n", "<localleader>RA", function()
  runner.run_all(true)
end, { desc = "run all cells of all languages", silent = true })

vim.env.QUARTO_PYTHON = vim.fn.exepath("python")

vim.filetype.add({
  extension = {
    Rmd = "quarto",
    rmd = "quarto",
  },
})
