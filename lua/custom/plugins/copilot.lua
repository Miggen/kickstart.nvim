-- ~/.config/nvim/lua/plugins/copilot.lua
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        -- If you will use nvim-cmp, disable these to avoid “double” UI
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },
}
