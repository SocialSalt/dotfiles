vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" }, { confirm = false })

local lint = require("lint")
lint.linters_by_ft = {
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  json = { "jsonlint" },
  yaml = { "yamllint" },
  markdown = { "markdownlint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then
      lint.try_lint(nil, { ignore_errors = true })
    end
  end,
})
vim.keymap.set("n", "<leader>l", function()
  lint.try_lint()
end, { desc = "Trigger [L]inter" })
