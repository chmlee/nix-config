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
        schema = {
          model = {
            default = "mistral-small-latest",
            choices = {
              "mistral-small-latest",    -- fast & cheap: quick edits, autocomplete-ish Q&A
              "mistral-medium-latest",   -- balanced daily driver for stats + coding
              "mistral-large-latest",    -- heaviest reasoning: complex refactorings, tricky R/SQL
              "magistral-medium-latest", -- thinking model: math proofs, statistical derivations
              "codestral-latest",        -- code-specialized: great for Python/JS/Rust/SQL fill-in
              "open-mistral-nemo",       -- cheap fallback, good enough for simple stuff
            },
          },
        },
      })
    end,
  },
  strategies = {
    chat   = { adapter = "mistral" },
    inline = { adapter = "mistral" }, -- inline benefits from codestral: set default per-strategy below
    agent  = { adapter = "mistral" },
  },
  display = {
    chat = {
      render = "markdown", -- uses render-markdown.nvim if installed
      show_settings = true,
    },
  },
  opts = { log_level = "INFO" }, -- dropped from DEBUG; use "TRACE"/"DEBUG" only when debugging
})
