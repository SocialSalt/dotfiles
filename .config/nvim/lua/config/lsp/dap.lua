vim.pack.add({
  "https://github.com/rcarriga/nvim-dap-ui",
  -- Required dependency for nvim-dap-ui
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/jay-babu/mason-nvim-dap.nvim",
  "https://github.com/leoluz/nvim-dap-go",
  "https://github.com/mfussenegger/nvim-dap-python",
  "https://github.com/mfussenegger/nvim-dap",
}, { confirm = false, load = true })

-- require("dap").setup()
dap = require("dap")
vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F1>", require("dap").step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F2>", require("dap").step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F3>", require("dap").step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>b", function()
  -- dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  dap.toggle_breakpoint()
end, { desc = "Debug: Set Breakpoint" })

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
  controls = {
    icons = {
      pause = "⏸",
      play = "▶",
      step_into = "⏎",
      step_over = "⏭",
      step_out = "⏮",
      step_back = "b",
      run_last = "▶▶",
      terminate = "⏹",
      disconnect = "⏏",
    },
  },
})
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set("n", "<F7>", require("dapui").toggle, { desc = "Debug: See last session result." })

-- Install golang specific config
require("dap-go").setup({ delve = { detached = vim.fn.has("win32") == 0 } })
vim.keymap.set("n", "<leader>tg", require("dap-go").debug_test, { desc = "dap [T]est [G]o function" })

-- Install python specific config
local dap_python = require("dap-python")
dap_python.setup("python")
dap_python.test_runner = "pytest"
vim.keymap.set("n", "<leader>tp", dap_python.test_method, { desc = "dap [T]est [P]ython function" })
