local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")
local log = require("telescope.log")
local flatten = require("telescope.utils").flatten

local custom_picker = {}

local to_live_grep = function(prompt_bufnr, opts)
  opts = opts or {}
  opts.prefix = "Grep over files"
  opts.prompt_to_prefix = vim.F.if_nil(opts.prompt_to_prefix, false)
  opts.prefix_hl_group = vim.F.if_nil(opts.prompt_hl_group, "TelescopePromptPrefix")
  opts.prompt_prefix = vim.F.if_nil(opts.prompt_prefix, conf.prompt_prefix)
  opts.reset_multi_selection = vim.F.if_nil(opts.reset_multi_selection, false)
  opts.reset_prompt = vim.F.if_nil(opts.reset_prompt, true)
  -- opts.sorter = vim.F.if_nil(opts.sorter, conf.generic_sorter({}))
  opts.sorter = sorters.highlighter_only(opts)
  opts.push_cursor_on_edit = true

  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local current_line = action_state.get_current_line()
  opts.prompt_title = string.format("Grep Files Matching, (%s)", current_line)

  -- if current_picker.layout.prompt.border then
  --   current_picker.layout.prompt.border:change_title(string.format("Grep Files Matching, (%s)", current_line))
  -- end

  action_state.get_current_history():append(current_line, current_picker, false)

  local results = {}
  for entry in current_picker.manager:iter() do
    table.insert(results, entry[1])
  end

  local grepper_function = function(prompt)
    if not prompt or prompt == "" then
      return nil
    end
    return utils.flatten({ conf.vimgrep_arguments, "--", prompt, results })
  end

  local new_finder = finders.new_job(grepper_function, make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)
  current_picker:refresh(new_finder, opts)
end

custom_picker.grep_after_file = function(opts)
  local find_command = (function()
    if opts.find_command then
      if type(opts.find_command) == "function" then
        return opts.find_command(opts)
      end
      return opts.find_command
    elseif 1 == vim.fn.executable("rg") then
      return { "rg", "--files", "--color", "never" }
    elseif 1 == vim.fn.executable("fd") then
      return { "fd", "--type", "f", "--color", "never" }
    elseif 1 == vim.fn.executable("fdfind") then
      return { "fdfind", "--type", "f", "--color", "never" }
    elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
      return { "find", ".", "-type", "f" }
    elseif 1 == vim.fn.executable("where") then
      return { "where", "/r", ".", "*" }
    end
  end)()

  if not find_command then
    utils.notify("builtin.find_files", {
      msg = "You need to install either find, fd, or rg",
      level = "ERROR",
    })
    return
  end

  local command = find_command[1]
  local hidden = opts.hidden
  local no_ignore = opts.no_ignore
  local no_ignore_parent = opts.no_ignore_parent
  local follow = opts.follow
  local search_dirs = opts.search_dirs
  local search_file = opts.search_file

  if search_dirs then
    for k, v in pairs(search_dirs) do
      search_dirs[k] = utils.path_expand(v)
    end
  end

  if command == "fd" or command == "fdfind" or command == "rg" then
    if hidden then
      find_command[#find_command + 1] = "--hidden"
    end
    if no_ignore then
      find_command[#find_command + 1] = "--no-ignore"
    end
    if no_ignore_parent then
      find_command[#find_command + 1] = "--no-ignore-parent"
    end
    if follow then
      find_command[#find_command + 1] = "-L"
    end
    if search_file then
      if command == "rg" then
        find_command[#find_command + 1] = "-g"
        find_command[#find_command + 1] = "*" .. search_file .. "*"
      else
        find_command[#find_command + 1] = search_file
      end
    end
    if search_dirs then
      if command ~= "rg" and not search_file then
        find_command[#find_command + 1] = "."
      end
      vim.list_extend(find_command, search_dirs)
    end
  elseif command == "find" then
    if not hidden then
      table.insert(find_command, { "-not", "-path", "*/.*" })
      find_command = flatten(find_command)
    end
    if no_ignore ~= nil then
      log.warn("The `no_ignore` key is not available for the `find` command in `find_files`.")
    end
    if no_ignore_parent ~= nil then
      log.warn("The `no_ignore_parent` key is not available for the `find` command in `find_files`.")
    end
    if follow then
      table.insert(find_command, 2, "-L")
    end
    if search_file then
      table.insert(find_command, "-name")
      table.insert(find_command, "*" .. search_file .. "*")
    end
    if search_dirs then
      table.remove(find_command, 2)
      for _, v in pairs(search_dirs) do
        table.insert(find_command, 2, v)
      end
    end
  elseif command == "where" then
    if hidden ~= nil then
      log.warn("The `hidden` key is not available for the Windows `where` command in `find_files`.")
    end
    if no_ignore ~= nil then
      log.warn("The `no_ignore` key is not available for the Windows `where` command in `find_files`.")
    end
    if no_ignore_parent ~= nil then
      log.warn("The `no_ignore_parent` key is not available for the Windows `where` command in `find_files`.")
    end
    if follow ~= nil then
      log.warn("The `follow` key is not available for the Windows `where` command in `find_files`.")
    end
    if search_dirs ~= nil then
      log.warn("The `search_dirs` key is not available for the Windows `where` command in `find_files`.")
    end
    if search_file ~= nil then
      log.warn("The `search_file` key is not available for the Windows `where` command in `find_files`.")
    end
  end

  if opts.cwd then
    opts.cwd = utils.path_expand(opts.cwd)
  end

  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  pickers
    .new(opts, {
      prompt_title = "Find Files",
      __locations_input = true,
      finder = finders.new_oneshot_job(find_command, opts),
      previewer = conf.grep_previewer(opts),
      sorter = sorters.prefilter({ sorter = conf.file_sorter(opts) }),
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<c-space>", function()
          to_live_grep(prompt_bufnr, opts)
        end)
        return true
      end,
    })
    :find()
end

local function apply_checks(mod)
  for k, v in pairs(mod) do
    mod[k] = function(opts)
      opts = opts or {}

      v(opts)
    end
  end

  return mod
end

-- custom_picker.grep_after_file()

return apply_checks(custom_picker)
