-- venv-selector requires fd/fdfind and doesn't work on Windows/WSL
local function is_supported()
  if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
    return false
  end
  if vim.fn.has 'wsl' == 1 then
    return false
  end
  return vim.fn.executable 'fd' == 1 or vim.fn.executable 'fdfind' == 1
end

return {
  'linux-cultist/venv-selector.nvim',
  enabled = is_supported,
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-dap-python',
    'nvim-telescope/telescope.nvim',
  },
  lazy = false,
  config = function()
    require('venv-selector').setup {}
  end,
  keys = {
    { ',v', '<cmd>VenvSelect<cr>' },
  },
}
