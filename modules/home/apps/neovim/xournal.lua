local function fig_id(name)
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  name = name:gsub("^figures/", "")
  name = name:gsub("%.xopp$", ""):gsub("%.pdf$", ""):gsub("%.png$", "")
  name = name:gsub("[^%w%-_]", "-")
  name = name:gsub("%s+", "-")
  name = name:lower()
  return name
end

local function xournal_blank_template()
  return table.concat({
    '<?xml version="1.0" standalone="no"?>',
    '<xournal creator="Xournal++" fileversion="4">',
    '<title>Xournal++ document - see https://github.com/xournalpp/xournalpp</title>',
    '<page width="595.27559" height="841.88976">',
    '<background type="solid" color="white" style="plain" />',
    '<layer />',
    '</page>',
    '</xournal>',
    '',
  }, "\n")
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

  -- seed a minimal valid .xopp so xournalpp opens an existing file
  -- instead of an untitled doc that needs renaming on save
  if vim.fn.filereadable(file) == 0 then
    local f = io.open(file, "w")
    if f then
      f:write(xournal_blank_template())
      f:close()
    else
      vim.notify("Could not create " .. file, vim.log.levels.ERROR)
      return
    end
  end

  vim.fn.jobstart({ "xournalpp", file }, { detach = true })
end, {
  nargs = "?",
  complete = "file",
})

vim.api.nvim_create_user_command("QFig", function(opts)
  local base = fig_id(opts.args)
  local id = base

  local lines = {
    "![TODO caption](figures/" .. base .. ".pdf){#fig-" .. id .. " width=70%}",
    "",
  }

  vim.api.nvim_put(lines, "l", true, true)
end, { nargs = 1 })

local xournal_watch_job = nil

local function figures_dir()
  return vim.fn.expand("%:p:h") .. "/figures"
end

local function export_all_xopp()
  local dir = figures_dir()
  vim.fn.mkdir(dir, "p")

  local files = vim.fn.glob(dir .. "/*.xopp", false, true)

  for _, file in ipairs(files) do
    local pdf = file:gsub("%.xopp$", ".pdf")

    vim.fn.jobstart({
      "xournalpp",
      "--create-pdf",
      pdf,
      file,
    }, {
      detach = true,
      on_stderr = function(_, data)
        if data then
          for _, line in ipairs(data) do
            if line ~= "" then
              vim.notify(line, vim.log.levels.WARN)
            end
          end
        end
      end,
    })
  end
end

vim.api.nvim_create_user_command("XournalExport", function()
  export_all_xopp()
  vim.notify("Exported Xournal++ figures", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("XournalWatch", function()
  if xournal_watch_job ~= nil then
    vim.notify("Xournal++ watcher already running", vim.log.levels.INFO)
    return
  end

  local dir = figures_dir()
  vim.fn.mkdir(dir, "p")

  local cmd = string.format(
    [[while true; do inotifywait -e close_write,move,create "%s"; for f in "%s"/*.xopp; do [ -e "$f" ] || continue; xournalpp --create-pdf "${f%%.xopp}.pdf" "$f"; done; done]],
    dir,
    dir
  )

  xournal_watch_job = vim.fn.jobstart({ "sh", "-c", cmd }, {
    detach = false,
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            vim.notify("[xournal] " .. line, vim.log.levels.INFO)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            vim.notify("[xournal] " .. line, vim.log.levels.WARN)
          end
        end
      end
    end,
    on_exit = function()
      xournal_watch_job = nil
      vim.notify("Xournal++ watcher stopped", vim.log.levels.INFO)
    end,
  })

  vim.notify("Started Xournal++ watcher", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("XournalWatchStop", function()
  if xournal_watch_job == nil then
    vim.notify("No Xournal++ watcher running", vim.log.levels.INFO)
    return
  end

  vim.fn.jobstop(xournal_watch_job)
  xournal_watch_job = nil
  vim.notify("Stopped Xournal++ watcher", vim.log.levels.INFO)
end, {})

local function figure_path_from_line()
  local line = vim.api.nvim_get_current_line()

  local path = line:match("%(figures/([%w%-%_%.]+)%)")
  if path then
    return "figures/" .. path
  end

  path = line:match("figures/([%w%-%_%.]+)%s*")
  if path then
    return "figures/" .. path
  end

  local tok = line:match("([%w%-%_%.%/]+%.xopp)")
      or line:match("([%w%-%_%.%/]+%.pdf)")
      or line:match("([%w%-%_%.%/]+%.png)")
  if tok then
    return tok
  end

  return nil
end

local function open_xournal_from_context()
  local name = figure_path_from_line()

  if not name then
    local word = vim.fn.expand("<cWORD>")
    if word and word ~= "" then
      name = fig_id(word)
    end
  end

  if not name or name == "" then
    vim.notify("No figure name found on line or under cursor", vim.log.levels.WARN)
    return
  end

  name = name:gsub("^%./", "")
  name = name:gsub("^figures/", "")
  name = name:gsub("%.pdf$", ".xopp"):gsub("%.png$", ".xopp")
  if not name:match("%.xopp$") then
    name = name .. ".xopp"
  end

  vim.cmd("Xournal " .. vim.fn.fnameescape(name))
end

vim.keymap.set("n", "<leader>x", open_xournal_from_context, {
  desc = "Open Xournal++ figure from cursor/line",
})

local function get_visual_selection()
  local mode = vim.fn.mode()

  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return nil
  end

  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local lines = vim.fn.getline(start_row, end_row)

  if #lines == 0 then
    return nil
  end

  lines[1] = string.sub(lines[1], start_col)
  lines[#lines] = string.sub(lines[#lines], 1, end_col)

  return table.concat(lines, "\n")
end

local function qfig_from_context()
  local name = get_visual_selection()

  if not name or name == "" then
    name = vim.fn.expand("<cWORD>")
  end

  if not name or name == "" then
    vim.notify("No figure name found", vim.log.levels.WARN)
    return
  end

  vim.cmd("QFig " .. vim.fn.fnameescape(fig_id(name)))
end

vim.keymap.set("n", "<C-y>,", qfig_from_context, {
  desc = "Expand word into Quarto figure",
})

vim.keymap.set("v", "<C-y>,", qfig_from_context, {
  desc = "Expand selection into Quarto figure",
})
