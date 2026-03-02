return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      opts = {
        log_level = "DEBUG",
      },
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
        cmd = {
          adapter = "gemini",
        },
      },
      -- adapters = {
      --   gemini = function()
      --     return require("codecompanion.adapters").extend("gemini", {
      --       defaults = {
      --         auth_method = "gemini-api-key",
      --       },
      --       env = {
      --         GEMINI_API_KEY = "GEMINI_API_KEY",
      --         api_key = "GEMINI_API_KEY", -- Redundant if GEMINI_API_KEY is used, but good for safety.
      --       },
      --     })
      --   end,
      -- },
    })

    -- Keymaps
    vim.keymap.set({ "n", "v" }, "<leader>ch", "<Cmd>CodeCompanionChat<CR>", { desc = "[C]ompanion C[h]at" })
    vim.keymap.set({ "n", "v" }, "<leader>cc", "<Cmd>CodeCompanionActions<CR>", { desc = "[C]ompanion [C]ompanion Actions" })
  end,
}
