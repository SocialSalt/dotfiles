vim.pack.add({
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/saghen/blink.lib",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
})

local cmp = require("blink.cmp")
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "blink.cmp" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("blink.cmp")
      end
      -- cmp.build():wait(60000)
    end
  end,
})

-- cmp.build():wait(60000)
cmp.setup({
  keymap = {
    -- 'default' (recommended) for mappings similar to built-in completions
    --   <c-y> to accept ([y]es) the completion.
    --    This will auto-import if your LSP supports it.
    --    This will expand snippets if the LSP sent a snippet.
    -- 'super-tab' for tab to accept
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- For an understanding of why the 'default' preset is recommended,
    -- you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --
    -- All presets have the following mappings:
    -- <tab>/<s-tab>: move to right/left of your snippet expansion
    -- <c-space>: Open menu or open docs if already open
    -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
    -- <c-e>: Hide menu
    -- <c-k>: Toggle signature help
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    preset = "default",

    -- NOTE: these don't actually take effect because preset = 'default'
    -- they are just here to remind me in case I need it
    ["<Tab>"] = false,
    ["<S-Tab>"] = false,

    ["<C-space>"] = { "show", "fallback" },

    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-S-N>"] = { "select_prev", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    -- ["<Right>"] = { "select_next", "fallback" },
    -- ["<Left>"] = { "select_prev", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },

    ["<C-y>"] = { "select_and_accept" },
    ["<C-e>"] = { "cancel" },

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
  },

  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
    providers = {
      lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },

  snippets = { preset = "luasnip" },

  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See :h blink-cmp-config-fuzzy for more information
  -- fuzzy = { implementation = "lua" },
  fuzzy = { implementation = "prefer_rust_with_warning" },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
})
