local tools = require 'utils.tools'

return {
  name = 'nixd',
  cmd = { tools.find_tool 'nixd' or 'nixd' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'flake.nix', 'default.nix', 'shell.nix' }, { upward = true })[1]),
  filetypes = { 'nix' },
}
