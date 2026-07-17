return {
  {
    'millerjason/neovimacs.nvim',
    opts = {
      VM_Enabled = vim.g.neovimacs_bindings,
      VM_StartInsert = vim.g.neovimacs_insert,
      TabIndentStyle = 'none', -- 'emacs', 'never', 'whitespace', 'startofline'
    },
  },
}
