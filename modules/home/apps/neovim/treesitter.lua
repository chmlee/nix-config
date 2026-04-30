vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local lang = vim.treesitter.language.get_lang(ft)

    if not lang or not vim.treesitter.language.add(lang) then
      return
    end

    vim.treesitter.start()

    -- Set folding if available
    if vim.treesitter.query.get(lang, "folds") then
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end

    -- Set indentation if available (overrides traditional indent)
    if vim.treesitter.query.get(lang, "indents") then
      vim.bo.indentexpr = "nvim_treesitter#indent()"
    end
  end
})
