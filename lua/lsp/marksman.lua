local tools = require 'utils.tools'

return {
  name = 'marksman',
  cmd = { tools.find_tool 'marksman' or 'marksman', 'server' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git', '.marksman.toml' }, { upward = true })[1]),
  filetypes = { 'markdown', 'md' },
}
