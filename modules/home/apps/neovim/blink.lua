require('blink.cmp').setup({
  keymap = {
    preset = 'none', -- Use 'none' to avoid hidden key conflicts
    ['<C-n>'] = { 
      function(cmp)
        if cmp.is_menu_visible() then return cmp.select_next() end
        return cmp.show() 
      end,
      'fallback' 
    },
    ['<C-p>'] = { 
      function(cmp)
        if cmp.is_menu_visible() then return cmp.select_prev() end
      end,
      'fallback' 
    },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-b>'] = { 'scroll_documentation_down', 'fallback' },
  },

  completion = {
    list = {
      selection = {
        preselect = false,   -- Essential to avoid the "frozen" state
        auto_insert = true,  -- Makes it feel like native Vim
      },
    },
    documentation = {
      auto_show = true,
      window = { border = "single" },
    },
    menu = { border = "single" },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'otter' },
    providers = {
      -- We fix the error here by removing fallback_for
      otter = {
        name = 'otter',
        module = 'blink.compat.source',
        score_offset = 100,
      },
      -- According to your error message, we apply the fallback here
      lsp = {
        fallbacks = { 'otter' }, 
      },
    },
  },
})
