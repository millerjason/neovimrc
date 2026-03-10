local tools = require 'utils.tools'

return {
  name = 'taplo',
  cmd = { tools.find_tool 'taplo' or 'taplo', 'lsp', 'stdio' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git', '*.toml' }, { upward = true })[1]),
  filetypes = { 'toml' },
}
