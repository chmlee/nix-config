require("codecompanion").setup({
  adapters = {
    mistral = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          api_key = "MISTRAL_API_KEY",
          url = "https://api.mistral.ai/v1",
          chat_url = "/chat/completions",
        },
        name = "mistral",
        schema = { model = { default = "mistral-small-latest" } },
      })
    end,
  },
  strategies = {
    chat = { adapter = "mistral" },
    inline = { adapter = "mistral" },
  },
})
