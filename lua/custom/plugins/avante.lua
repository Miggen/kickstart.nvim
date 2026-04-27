return {
  {
    'yetone/avante.nvim',
    build = 'make',
    event = 'VeryLazy',
    enabled = false,
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- proxy = "http://127.0.0.1:8080",
      provider = 'qgenie',
      providers = {
        qgenie = {
          __inherited_from = 'openai',
          allow_insecure = true,
          endpoint = 'https://qgenie-api.qualcomm.com/v1/',
          model = 'anthropic::claude-4-6-sonnet',
          -- model = "Pro",
          api_key_name = 'QGENIE_API_KEY',
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            max_tokens = 16000,
          },
          disabled_tools = { 'web_search' },
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    },
    selector = {
      provider = 'telescope',
      provider_opts = {},
    },
  },
}
