local builtin = require 'telescope.builtin'

vim.keymap.set('n', '<C-s>', function()
  builtin.current_buffer_fuzzy_find()
end)
vim.keymap.set('i', '<C-s>', function()
  builtin.current_buffer_fuzzy_find()
end)
vim.keymap.set('c', '<C-s>', function()
  builtin.current_buffer_fuzzy_find()
end)
