require("codecompanion").setup({
  interactions = {
    chat = {
      adapter = "openai",
      model = "mistral-small",
      -- Move these inside the chat table:
      api_key = vim.env.MISTRAL_API_KEY,  -- Use vim.env instead of os.getenv
      base_url = "https://api.mistral.ai/v1",
    },
  },
  opts = {
    log_level = "DEBUG",
  },
})
