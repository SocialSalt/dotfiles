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
          adapter = "gemini_cli",
        },
        inline = {
          adapter = "gemini_cli",
        },
        cmd = {
          adapter = "gemini_cli",
        },
      },
      adapters = {
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              env = {
                api_key = "GEMINI_API_KEY",
              },
            })
          end,
        },
      },
    })
    vim.keymap.set({ "n" }, "<leader>ch", "<Cmd>CodeCompanionChat<CR>", { desc = "[C]ompanion C[h]at" })
    vim.keymap.set({ "n" }, "<leader>cc", "<Cmd>CodeCompanionActions<CR>", { desc = "[C]ompanion [C]ompanion Actions" })
  end,
}
