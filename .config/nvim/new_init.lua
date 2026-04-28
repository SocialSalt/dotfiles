require("custom.options")
require("custom.commands")
require("custom.keymaps")
require("custom.autocommands")

vim.pack.add({
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  -- Git plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },
})
