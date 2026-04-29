vim.pack.add({
  "https://github.com/tpope/vim-sleuth",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/folke/todo-comments.nvim",
})

require("Comment").setup({})

require("which-key").setup({
  -- delay between pressing a key and opening which-key (milliseconds)
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },

  -- Document existing key chains
  spec = {
    { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
    { "<leader>t", group = "[T]oggle" },
    { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
  },
})

require("lazydev").setup({
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

require("todo-comments").setup({
  signs = false,
})
