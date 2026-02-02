return {
  {
    -- Chat UI for GitHub Copilot
    'CopilotC-Nvim/CopilotChat.nvim',
    -- You can pin a branch like 'main' if you prefer
    -- branch = 'main',
    dependencies = {
      -- Either copilot.lua or copilot.vim acts as the Copilot backend
      -- You already use copilot.lua; keep suggestion/panel disabled there.
      -- If you were on copilot.vim instead, list it here.
      -- 'github/copilot.vim',
      'nvim-lua/plenary.nvim', -- required
    },
    build = 'make tiktoken', -- optional but improves token counting on Linux/macOS
    event = 'VeryLazy',
    opts = {
      -- sensible defaults; you can customize later
      -- see :h CopilotChat for all options
      window = { width = 0.4 }, -- split width when in vertical layout
      auto_insert_mode = true, -- start in insert mode inside chat buffer
    },
    keys = {
      -- Toggle chat UI
      {
        '<leader>aa',
        function()
          require('CopilotChat').toggle()
        end,
        desc = 'CopilotChat: Toggle',
        mode = { 'n', 'x' },
      },
      -- Quick one‑off question (prompts for input)
      {
        '<leader>aq',
        function()
          vim.ui.input({ prompt = 'Quick Chat: ' }, function(input)
            if input and input ~= '' then
              require('CopilotChat').ask(input)
            end
          end)
        end,
        desc = 'CopilotChat: Quick Ask',
        mode = { 'n', 'x' },
      },
      -- Common actions
      {
        '<leader>ap',
        function()
          require('CopilotChat').select_prompt()
        end,
        desc = 'CopilotChat: Prompt Actions',
        mode = { 'n', 'x' },
      },
      {
        '<leader>ax',
        function()
          require('CopilotChat').reset()
        end,
        desc = 'CopilotChat: Clear Session',
        mode = { 'n', 'x' },
      },
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'
      chat.setup(opts)

      -- Tweak UI in chat buffers (optional)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    end,
  },
}
