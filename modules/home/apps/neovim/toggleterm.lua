require("toggleterm").setup()

vim.keymap.set("n", "<Leader>tt", '<cmd>ToggleTerm direction=float<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tv", '<cmd>ToggleTerm direction=vertical<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>th", '<cmd>ToggleTerm direction=horizontal<CR>', { noremap = true, silent = true })

local function run_in_tt(direction)
  local run_cmds = {
    python = "python3",
    r = "Rscript",
    sh = "bash",
    nix = "nix-instantiate --eval"
  }

  local ft = vim.bo.filetype
  local cmd_prefix = run_cmds[ft]

  if cmd_prefix then
    local file = vim.fn.expand("%")
    local full_cmd = cmd_prefix .. " " .. file
    local size_arg = direction == "vertical" and " size=50" or ""
    vim.cmd("TermExec cmd='" .. full_cmd .. "' direction='" .. direction .. "'" .. size_arg)
  end
end

local function run_file_float()
  run_in_tt("float")
end

local function run_file_right()
  run_in_tt("vertical")
end

vim.keymap.set("n", "<leader>trf", run_file_float)
vim.keymap.set("n", "<leader>trr", run_file_right)
