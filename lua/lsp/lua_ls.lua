local tools = require 'utils.tools'

local capabilities = tools.get_lsp_capabilities()

-- Lua LSP configuration for vim.lsp.enable()
return {
  name = 'lua_ls',
  cmd = { tools.find_tool 'lua-language-server' or 'lua-language-server' },
  filetypes = { 'lua' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.luarc.json', '.luarc.jsonc', '.stylua.toml', 'stylua.toml', 'selene.toml' }, { upward = true })[1]),
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
