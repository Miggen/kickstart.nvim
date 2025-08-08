-- Adds support for git review gui

return {
  {
    'sindrets/diffview.nvim',
    config = function()
      local diffview = require 'diffview'

      -- Keybindings for diffview
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Open diffview for current branch vs HEAD
      map('n', '<leader>do', function()
        diffview.open 'origin/main...HEAD'
      end, { desc = '[d]iffview [o]pen against origin/main' })

      -- Close diffview
      map('n', '<leader>dc', function()
        diffview.close()
      end, { desc = '[d]iffview [c]lose' })

      -- Open file history
      map('n', '<leader>dh', function()
        diffview.file_history()
      end, { desc = '[d]iffview file [h]istory' })

      -- Open file history for current file
      map('n', '<leader>dH', ':DiffviewFileHistory %<CR>', { desc = '[d]iffview current file [H]istory' })
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}
