vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { confirm = false })

local misc = require("mini.misc")
local later = function(f)
  misc.safely("later", f)
end

later(function()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      json = { "jq" },
      go = { "goimports", "gofumpt" },
      bash = { "shfmt" },
      typescript = { "oxfmt" },
      typescriptreact = { "oxfmt" },
      yaml = { "yq" },
      python = { "ruff_organize_imports", "ruff_format" },
      javascript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
    },

    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "never" }
    end,
  })
end)

vim.keymap.set("n", "<leader>tff", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
end, { desc = "Toggle auto format" })
