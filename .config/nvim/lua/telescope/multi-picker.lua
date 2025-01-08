return require("telescope").register_extension({
  setup = function(ext_config, config) end,
  exports = {
    multi_picker = require("multi_picker").file_after_grep,
  },
})
