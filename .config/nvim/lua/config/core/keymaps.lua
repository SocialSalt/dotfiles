vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ golang specific keymap ]]
vim.keymap.set("n", "<leader>en", "Aif err != nil {<CR><CR>}<Esc>ki<TAB><Esc>", { desc = "Insert if err != nil {}" })

-- [[ Spellcheck keymap ]]
vim.keymap.set("n", "<leader>zz", "<CMD>setlocal spell spelllang=en_us<CR>", { desc = "Turn on spell check for current buffer" })
vim.keymap.set("n", "<leader>zs", "<CMD>setlocal spell!<CR>", { desc = "Turn off spell check for current buffer" })

-- [[ swap line remap ]]
vim.keymap.set("n", "<leader>m", "ddp", { desc = "Move current line one line down" })
vim.keymap.set("n", "<leader>M", "ddkkp", { desc = "Move current line one line up" })

-- [[ jq keymaps ]]
vim.keymap.set("n", "<leader>jq", "<Cmd>%!jq<CR>", { desc = "format document with jq" })
vim.keymap.set("v", "<leader>jq", ":'<,'>!jq | unexpand -t2<CR>", { desc = "format selection with jq using tabs" })
vim.keymap.set("v", "<leader>jsq", ":'<,'>!jq<CR>", { desc = "format selection with jq (using spaces)" })
