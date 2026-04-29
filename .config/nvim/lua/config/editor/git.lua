vim.pack.add({

  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-rhubarb",
  "https://github.com/lewis6991/gitsigns.nvim",
})

require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  watch_gitdir = {
    follow_files = true,
  },
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 50,
  },
  current_line_blame_formatter = "\t\t<author>, <author_time:%Y-%m-%d> - <summary>",
})
