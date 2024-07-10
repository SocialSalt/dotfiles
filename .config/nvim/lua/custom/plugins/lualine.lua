return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = true,
      theme = "nightfox",
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      lualine_c = {
        {
          "filename",
          file_status = true,
          path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path,
        },
        {
          function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local is_modified = vim.api.nvim_get_option_value("modified", { buf = buf })
              local is_file = BufIsFile(buf)
              if is_modified and is_file then
                return "[~]"
              end
            end
            return ""
          end,
        },
      },
      lualine_y = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "filetype" },
      lualine_y = { "location" },
      lualine_z = {},
    },
  },
}
