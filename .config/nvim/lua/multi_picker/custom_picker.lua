local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")

local custom_picker = {}

local to_live_grep = function(prompt_bufnr, opts)
  opts = opts or {}
  opts.prefix = action_state.get_current_picker(prompt_bufnr).prompt_title
  opts.prompt_to_prefix = vim.F.if_nil(opts.prompt_to_prefix, false)
  opts.prefix_hl_group = vim.F.if_nil(opts.prompt_hl_group, "TelescopePromptPrefix")
  opts.prompt_prefix = vim.F.if_nil(opts.prompt_prefix, conf.prompt_prefix)
  opts.reset_multi_selection = vim.F.if_nil(opts.reset_multi_selection, false)
  opts.reset_prompt = vim.F.if_nil(opts.reset_prompt, true)
  opts.sorter = vim.F.if_nil(opts.sorter, conf.generic_sorter({}))

  local current_picker = action_state.get_current_picker(prompt_bufnr)

  local results = {}
  for entry in current_picker.manager:iter() do
    table.insert(results, entry[1])
  end

  -- action_state.get_current_history():append(current_line, current_picker)
  local grepper_function = function(prompt)
    if not prompt or prompt == "" then
      return nil
    end
    return utils.flatten({ conf.vimgrep_arguments, "--", prompt, results })
  end

  -- local line = action_state.get_current_line()
  -- if current_picker.layout.prompt.border then
  --   current_picker.layout.prompt.border:change_title(string.format("%s, (%s)", opts.prefix, line))
  -- end

  local new_finder = finders.new_job(grepper_function, make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)
  current_picker:refresh(new_finder, opts)
end

custom_picker.grep_after_file = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Find Files",
      finder = finders.new_oneshot_job({ "rg", "--files", "--color", "never" }, opts),
      -- sorter = conf.file_sorter(opts),
      sorter = sorters.prefilter({ sorter = conf.file_sorter(opts) }),
      previewer = conf.grep_previewer(opts),
      attach_mappings = function(_, map)
        map("i", "<c-space>", to_live_grep)
        return true
      end,
    })
    :find()
end

-- custom_picker.grep_after_file()

return custom_picker
