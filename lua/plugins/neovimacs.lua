return {
  {
    'millerjason/neovimacs.nvim',
    branch = 'feature/lua_rewrite',
    opts = {
      VM_Enabled = vim.g.neovimacs_bindings,
      VM_StartInsert = vim.g.neovimacs_insert,
      TabIndentStyle = 'none', -- 'emacs', 'never', 'whitespace', 'startofline'
    },
  },
}
