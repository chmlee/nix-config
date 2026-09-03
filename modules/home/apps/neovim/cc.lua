local cc = require("codecompanion")

cc.setup({
  adapters = {
    acp = {
      codex = function()
        return require("codecompanion.adapters").extend("codex", {
          defaults = {
            auth_method = "chat-gpt",
          },
        })
      end,
    },
  },

  interactions = {
    chat = {
      adapter = "codex",
    },
  },
})

vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", {
  desc = "AI chat",
})

vim.keymap.set("n", "<leader>an", "<cmd>CodeCompanionChat<cr>", {
  desc = "AI new chat",
})

vim.keymap.set("v", "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", {
  desc = "AI add selection",
})

vim.keymap.set({ "n", "v" }, "<leader>ap", "<cmd>CodeCompanionActions<cr>", {
  desc = "AI actions",
})
