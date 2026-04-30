vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/tpope/vim-sleuth",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/folke/flash.nvim",
  "https://github.com/folke/todo-comments.nvim",
})
local misc = require("mini.misc")
local later = function(f)
  misc.safely("later", f)
end
local on_event = function(ev, f)
  misc.safely("event:" .. ev, f)
end

require("Comment").setup()

on_event("VimEnter", function()
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
end)

require("lazydev").setup({
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

later(function()
  require("todo-comments").setup({
    signs = false,
  })
end)

require("flash").setup({})
vim.keymap.set({ "n", "x", "o" }, "<c-space>", function()
  require("flash").treesitter({
    actions = {
      ["<c-space>"] = "next",
      ["<M-space>"] = "prev",
    },
  })
end, { desc = "Treesitter incremental selection" })
