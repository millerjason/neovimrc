local tools = require 'utils.tools'

return {
  name = 'bashls',
  cmd = { tools.find_tool 'bash-language-server' or 'bash-language-server', 'start' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
  filetypes = { 'sh', 'bash' },
}
