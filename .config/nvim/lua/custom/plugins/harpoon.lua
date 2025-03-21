return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
    vim.keymap.set("n", "<leader>hm", function()
      harpoon:list():add()
    end)
    vim.keymap.set("n", "<leader>ha", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set("n", "<M-h>", function()
      harpoon:list():select(1)
    end)
    vim.keymap.set("n", "<M-j>", function()
      harpoon:list():select(2)
    end)
    vim.keymap.set("n", "<M-k>", function()
      harpoon:list():select(3)
    end)
    vim.keymap.set("n", "<M-l>", function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-p>", function()
      harpoon:list():prev()
    end)
    vim.keymap.set("n", "<C-S-n>", function()
      harpoon:list():next()
    end)
  end,
}
