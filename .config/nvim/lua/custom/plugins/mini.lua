return {
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()
    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
    --
    --
    --
    --
    -- Mini Trailspace
    local mini_trailspace = require("mini.trailspace")
    mini_trailspace.setup()

    vim.keymap.set("n", "<leader>tw", ":lua MiniTrailspace.trim()<CR>:w<CR>", { desc = "Trim trailing whitespace" })
    vim.keymap.set("n", "<leader>tl", ":lua MiniTrailspace.trim_last_lines()<CR>:w<CR>", { desc = "Trim trailing empty lines" })
  end,
}
