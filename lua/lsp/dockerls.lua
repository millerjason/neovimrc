local tools = require 'utils.tools'

return {
  name = 'dockerls',
  cmd = { tools.find_tool 'docker-langserver' or 'docker-langserver', '--stdio' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'Dockerfile', 'dockerfile', '.dockerignore' }, { upward = true })[1]),
  filetypes = { 'dockerfile', 'Dockerfile' },
}
