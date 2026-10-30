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

-- Setup debugpy adapter: prefer Mason's debugpy venv, then system python3
local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
if vim.fn.executable(mason_debugpy) == 1 then
  dap_python.setup(mason_debugpy)
else
  dap_python.setup("python3")
end

dap_python.test_runner = "pytest"

-- Resolve the local virtual environment (e.g. .venv created by uv)
dap_python.resolve_python = function()
  -- 1. Check if an environment is already active in the shell
  if vim.env.VIRTUAL_ENV then
    local path = vim.env.VIRTUAL_ENV .. "/bin/python"
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  -- 2. Search upward from the current buffer's file location for .venv
  local current_file = vim.api.nvim_buf_get_name(0)
  local search_dir = current_file ~= "" and vim.fs.dirname(current_file) or vim.fn.getcwd()
  local venv = vim.fs.find(".venv", { upward = true, path = search_dir })[1]
  if venv then
    local path = venv .. "/bin/python"
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  -- 3. Check current working directory
  local cwd_path = vim.fn.getcwd() .. "/.venv/bin/python"
  if vim.fn.executable(cwd_path) == 1 then
    return cwd_path
  end

  -- 4. Fallback to system python3
  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python3"
end

vim.keymap.set("n", "<leader>tp", dap_python.test_method, { desc = "dap [T]est [P]ython function" })
