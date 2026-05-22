local function slugify(s)
  s = s:gsub("%.xopp$", ""):gsub("%.pdf$", ""):gsub("%.png$", "")
  s = s:gsub("%s+", "-")
  s = s:gsub("[^%w%-_]", "-")
  s = s:lower()
  return s
end

vim.api.nvim_create_user_command("Xournal", function(opts)
  local name = opts.args

  if name == "" then
    name = os.date("%Y-%m-%d-%H%M") .. ".xopp"
  end

  if not name:match("%.xopp$") then
    name = name .. ".xopp"
  end

  local dir = vim.fn.expand("%:p:h") .. "/figures"
  vim.fn.mkdir(dir, "p")

  local file = dir .. "/" .. name
  vim.fn.jobstart({ "xournalpp", file }, { detach = true })
end, {
  nargs = "?",
  complete = "file",
})

vim.api.nvim_create_user_command("QFig", function(opts)
  local base = slugify(opts.args)
  local id = base:gsub("_", "-")

  local lines = {
    "![TODO caption](figures/" .. base .. ".pdf){#fig-" .. id .. " width=70%}",
    "",
  }

  vim.api.nvim_put(lines, "l", true, true)
end, { nargs = 1 })
