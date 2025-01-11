return require("telescope").register_extension({
  setup = function(ext_config, config) end,
  exports = {
    grep_after_file = require("multi_picker.custom_picker").grep_after_file,
  },
})
