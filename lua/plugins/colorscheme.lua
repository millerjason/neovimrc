return {
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      -- vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      on_highlights = function(hl, c)
        hl.TelescopeNormal = {
          fg = c.fg_dark,
        }
      end,
    },
  },
}
