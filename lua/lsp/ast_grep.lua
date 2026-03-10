local tools = require 'utils.tools'

return {
  name = 'ast_grep',
  cmd = { tools.find_tool 'ast-grep' or 'ast-grep', 'lsp' },
  filetypes = { 'java', 'javascript', 'html' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]) or vim.fn.getcwd(),
  settings = {
    ['ast-grep'] = {
      enable = true,
    },
  },
}
