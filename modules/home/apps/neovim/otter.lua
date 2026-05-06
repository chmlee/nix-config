local otter = require("otter")

otter.setup({
  buffers = {
    write_to_disk = true,
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "quarto",
  callback = function()
    -- Otter will 'spawn' a hidden python buffer and attach basedpyright to it
    otter.activate({"python"}, {
      lsp = {
        hover = true,
        definition = true,
      }
    })
  end,
})
