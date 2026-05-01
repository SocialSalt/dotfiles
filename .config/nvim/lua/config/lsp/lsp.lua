vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
}, { confirm = false })



-- stylua: ignore start
local lsps = vim
  .iter(require("config.lsp.languages"))
  :map(function(lang) return lang.lsp end)
  :filter(function(lsp) return lsp end)
  :flatten()
  :totable()
-- stylua: ignore end
vim.lsp.enable(lsps)

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- local capabilities = require("blink.cmp").get_lsp_capabilities()
-- for _, server in pairs(lsps) do
--   vim.lsp.config[server].setup({ capabilities = capabilities })
-- end

local telescope_builtin = require("telescope.builtin")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("socialsalt-lsp-attach", { clear = true }),
  callback = function(event)
    local set_keymap = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end
    set_keymap("n", "gd", telescope_builtin.lsp_definitions, "[G]o to [D]efinition")
    set_keymap("n", "gr", telescope_builtin.lsp_references, "[G]o to [R]eferences")
    set_keymap("n", "gi", telescope_builtin.lsp_implementations, "[G]o to [I]mplementation")
    set_keymap("n", "<leader>D", telescope_builtin.lsp_type_definitions, "Goto Definition")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup("socialsalt-lsp-highlight", { clear = false })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("socialsalt-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "socialsalt-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, event.buf) then
      if client.server_capabilities.completionProvider and client.server_capabilities.completionProvider.triggerCharacters then
        local triggers = vim.tbl_filter(function(char)
          return char ~= " "
        end, client.server_capabilities.completionProvider.triggerCharacters)
        client.server_capabilities.completionProvider.triggerCharacters = triggers
      end
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      set_keymap("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, "[T]oggle Inlay [H]ints")
    end

    set_keymap({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ctions")
    set_keymap("n", "<leader>rn", vim.lsp.buf.rename, "[C]ode [R]ename")
    set_keymap("n", "<leader>k", vim.lsp.buf.hover, "Hover Documentation")
    set_keymap("n", "K", vim.lsp.buf.hover, "Hover (alt)")
    set_keymap("n", "gD", vim.lsp.buf.declaration, "Goto Definition")
  end,
})
