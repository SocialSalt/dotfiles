vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "master" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/jemag/telescope-diff.nvim" },
}, { confirm = false })

require("nvim-web-devicons").setup({ enabled = vim.g.have_nerd_font })
require("nvim-web-devicons").set_icon({
  go = {
    icon = "",
    -- icon = '',
    color = "#5DC9E2",
    cterm_color = "75",
    name = "go",
  },
  rs = {
    icon = "",
    name = "rs",
    color = "#F74C00",
    cterm_color = "166",
  },
})

local telescope_config = require("telescope.config")
-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!{**/.git/*,**/node_modules/*,**/package-lock.json,**/yarn.lock,**/poetry.lock}")

require("telescope").setup({
  -- You can put your default mappings / updates / etc. in here
  --  All the info you're looking for is in `:help telescope.setup()`
  defaults = {
    mappings = {
      -- i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
    vimgrep_arguments = vimgrep_arguments,
    file_ignore_patterns = { "^.git/" },
  },
  pickers = {
    find_files = {
      hidden = true,
      -- find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
    -- ["multi_picker"] = {
    --   require("telescope").load_extension("multi_picker"),
    -- },
  },
})
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
-- vim.keymap.set(
--   "n",
--   "<leader>sm",
--   require("telescope").extensions.multi_picker.grep_after_file,
--   { desc = "[S]earch [M]ultipicker <C-space> -> grep files" }
-- )

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set("n", "<leader>s/", function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "[S]earch [/] in Open Files" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

require("telescope").load_extension("diff")
vim.keymap.set("n", "<leader>df", function()
  require("telescope").extensions.diff.diff_files({ hidden = true })
end, { desc = "Compare 2 files" })
vim.keymap.set("n", "<leader>dc", function()
  require("telescope").extensions.diff.diff_current({ hidden = true })
end, { desc = "Compare file with current" })
