vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.nvim", version = "main" },
  { src = "https://github.com/nvim-mini/mini.pairs", version = "main" },
  { src = "https://github.com/nvim-mini/mini.icons", version = "main" },
  { src = "https://github.com/nvim-mini/mini.snippets", version = "main" },
  { src = "https://github.com/nvim-mini/mini.completion", version = "main" },
  -- { src = "https://github.com/nvim-mini/mini.statusline", version = "main" },
})
require("mini.pairs").setup({})
-- Better Around/Inside textobjects
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
require("mini.ai").setup({ n_lines = 500 })

-- Add/delete/replace surroundings (brackets, quotes, etc.)
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()

require("mini.icons").setup()
require("mini.snippets").setup()
require("mini.completion").setup()

require("mini.trailspace").setup()
vim.keymap.set("n", "<leader>tw", ":lua MiniTrailspace.trim()<CR>:w<CR>", { desc = "Trim trailing whitespace" })
vim.keymap.set("n", "<leader>tl", ":lua MiniTrailspace.trim_last_lines()<CR>:w<CR>", { desc = "Trim trailing empty lines" })

-- local statusline = require("mini.statusline")
-- local custom_line = function()
--   local mode, mode_hl = statusline.section_mode({ trunc_width = 100 })
--   local git = statusline.section_git({ trunc_width = 75 })
--   local diff = MiniStatusline.section_diff({ trunc_width = 75 })
--   -- local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
--   -- local lsp = statusline.section_lsp { trunc_width = 75 }
--   local filename = statusline.section_filename({ trunc_width = 140 })
--   local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
--   local location = statusline.section_location({ trunc_width = 75 })
--   local search = statusline.section_searchcount({ trunc_width = 75 })
--
--   return statusline.combine_groups({
--     { hl = mode_hl, strings = { mode } },
--     { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
--     "%<",
--     { hl = "MiniStatuslineFilename", strings = { filename } },
--     "%=",
--     { hl = "MiniStatuslineFileInfo", strings = { fileinfo } },
--     { hl = mode_hl, strings = { search, location } },
--   })
-- end
-- -- set use_icons to true if you have a Nerd Font
-- statusline.setup({
--   use_icons = vim.g.have_nerd_font,
--   content = {
--     active = custom_line,
--   },
-- })
