-- Provides interactive git conflict resolution with 3-way highlighting
-- and one-key commands to choose ours/theirs/both/none

return {
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = 'BufReadPre',
    opts = {
      default_mappings = false,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = 'copen',
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
      },
    },
    config = function(_, opts)
      require('git-conflict').setup(opts)

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
      end

      -- Choose a side
      map('n', '<leader>gO', '<Plug>(git-conflict-ours)', '[g]it conflict choose [O]urs')
      map('n', '<leader>gT', '<Plug>(git-conflict-theirs)', '[g]it conflict choose [T]heirs')
      map('n', '<leader>gB', '<Plug>(git-conflict-both)', '[g]it conflict choose [B]oth')
      map('n', '<leader>g0', '<Plug>(git-conflict-none)', '[g]it conflict choose n[0]ne')

      -- Navigate between conflicts
      map('n', '<leader>gN', '<Plug>(git-conflict-next-conflict)', '[g]it conflict [N]ext')
      map('n', '<leader>gP', '<Plug>(git-conflict-prev-conflict)', '[g]it conflict [P]rev')

      -- List all conflicts in quickfix
      map('n', '<leader>gX', '<cmd>GitConflictListQf<CR>', '[g]it conflict list quickfi[X]')
    end,
  },
}
