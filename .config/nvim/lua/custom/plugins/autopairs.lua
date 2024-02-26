-- File: lua/custom/plugins/autopairs.lua

return {
  "windwp/nvim-autopairs",
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function ()
    require("nvim-autopairs").setup {}
    local cmp_autpairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autpairs.on_confirm_done()
    )
  end,
}

