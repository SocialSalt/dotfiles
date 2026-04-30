vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { confirm = false })

local misc = require("mini.misc")
local later = function(f)
  misc.safely("later", f)
end
local on_event = function(ev, f)
  misc.safely("event:" .. ev, f)
end

on_event("BufWritePre", function()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      json = { "jq" },
      go = { "gofmt" },
      bash = { "shfmt" },
      typescript = { "oxlint", "oxfmt" },
      typescriptreact = { "oxlint", "oxfmt" },
      yaml = { "yq" },
      python = { "black" },
      javascript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
    },

    format_after_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  })
end)

vim.keymap.set("n", "<leader>tff", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
end, { desc = "Toggle auto format" })
