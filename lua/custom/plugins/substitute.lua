-- Adds support for git review gui

return {
  {
    'gbprod/substitute.nvim',
    config = function()
      local substitute = require 'substitute'

      substitute.setup()

      -- Keybindings for diffview
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Add [s]ubstitute functionality
      map('n', 's', substitute.operator, { noremap = true, desc = '[s]ubstitute a motion with paste buffer without overriding paste buffer' })
    end,
  },
}
