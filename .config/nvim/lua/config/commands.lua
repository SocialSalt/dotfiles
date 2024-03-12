local function map(tb, fn)
  local t = {}
  for k, v in pairs(tb) do
    t[k] = fn(v)
  end
  return t
end

vim.api.nvim_create_user_command("LSB", function()
  local modified_buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, 'modified') then
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


-- vim.api.nvim_create_user_command("DAP")
