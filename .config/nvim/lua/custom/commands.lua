local function map(tb, fn)
  local t = {}
  for k, v in pairs(tb) do
    t[k] = fn(v)
  end
  return t
end

function BufIsFile(buf)
  local ok_name = string.len(vim.api.nvim_buf_get_name(buf)) > 0
  local ok_type = vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
  local ok_swap = vim.api.nvim_get_option_value("swapfile", { buf = buf }) == true
  local ok_hide = vim.api.nvim_get_option_value("bufhidden", { buf = buf }) == ""
  local ok_mod = vim.api.nvim_get_option_value("modifiable", { buf = buf }) == true
  if ok_mod and ok_name and ok_type and ok_swap and ok_hide then
    return true
  end
  return false
end

-- command to list all unsaved buffers
vim.api.nvim_create_user_command("LSB", function()
  local modified_buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local is_file = BufIsFile(buf)
    local is_modified = vim.api.nvim_get_option_value("modified", { buf = buf })
    if is_file and is_modified then
      modified_buffers[#modified_buffers + 1] = buf
    end
  end
  if #modified_buffers > 0 then
    local buffer_names = table.concat(map(modified_buffers, vim.api.nvim_buf_get_name), "\n")
    print("Unsaved Buffers:")
    print(buffer_names)
  else
    print("No unsaved buffers")
  end
end, {})

-- This command ensure that `:E` isn't ambiguous
vim.api.nvim_create_user_command("E", function()
  vim.api.nvim_command("Explore")
end, {})

vim.api.nvim_create_autocmd("BufLeave", {
  desc = "Autosave buffer when leaving buffer window",
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  callback = function(event)
    local is_file = BufIsFile(event.buf)
    local is_modified = vim.api.nvim_get_option_value("modified", { buf = event.buf })
    if is_file and is_modified then
      vim.api.nvim_command("w")
    end
  end,
})

--  Reload LSP if file is renamed
vim.api.nvim_create_user_command("LR", function()
  local buffnr = vim.api.nvim_get_current_buf()
  vim.lsp.stop_client(vim.lsp.get_clients({ buffnr = buffnr }))
  vim.api.nvim_command("e")
end, {})
