-- ~/.config/nvim/lua/plugins/copilot.lua
return {
  {
    -- Copilot backend (Lua)
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false }, --  turns OFF ghost text
      panel = { enabled = false }, -- no side panel
      filetypes = {
        markdown = false,
        help = false,
      },
    },
  },
}
