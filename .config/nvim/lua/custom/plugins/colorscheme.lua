return {

  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- load the colorscheme here
    require('nightfox').setup({
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled", -- Compiled file suffix
        transparent = false,               -- Disable setting background
        terminal_colors = true,            -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        dim_inactive = false,              -- Non focused panes set to alternative backgroung
      },
      palettes = {
        nightfox = {
          bg1 = "#000000",
          bg0 = "#222222",
          green = "#ACDB66",
          red = "#C93E3C",
          blue = "#769BE8",
          purple = "#B383D1",
          cyan = "#78CEBE",
          orange = "#E48064",
          comment = "#505957",
        }
      },
      specs = {
        all = {
          syntax = {
            operator = "magenta",
            -- builtin0 = "#C93E3C",
            -- builtin1 = "#7ad5d6",
            -- builtin2 = "#f6b079",
            -- builtin3 = "#d16983",
            -- conditional = "#baa1e2",
            -- const = "#f6b079",
            -- dep = "#71839b",
            -- field = "#769BE8",
            -- func = "#86abdc",
            -- ident = "#78CEBE"
          },
        },
      },
      groups = {},
    })
    vim.cmd.colorscheme("nightfox")
  end,

  -- [[Stuff I tried and didn't like ]]
  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },
  -- {
  --   "oxfist/night-owl.nvim",
  --   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd.colorscheme("night-owl")
  --   end,
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = true,
  --   opts = {},
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd.colorscheme("gruvbox")
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd.colorscheme("tokyonight")
  --   end,
  -- },
}
