vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true

vim.o.mouse = 'a'

--vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)


vim.o.breakindent = true
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.colorcolumn = "80"

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 15

vim.o.confirm = true

vim.keymap.set('i', 'jk', '<Escape>')
vim.keymap.set('i', 'kj', '<Escape>')
vim.keymap.set("i", ",,", "<-")
--vim.keymap.set('i', 'jf', '<Escape>')


--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.expandtab = true
