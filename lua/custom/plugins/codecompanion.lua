local DEFAULT_MODEL = 'anthropic::claude-4-6-sonnet'

return {
  {
    'olimorris/codecompanion.nvim',
    event = 'VeryLazy',
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
      'j-hui/fidget.nvim',
      'lalitmee/codecompanion-spinners.nvim',
    },

    opts = {
      ----------------------------------------------------------------------
      -- INLINE STRATEGY FIX (required for Anthropic/QGenie)
      ----------------------------------------------------------------------
      inline = {
        format = 'diff',
      },

      ----------------------------------------------------------------------
      -- PRESETS
      ----------------------------------------------------------------------
      presets = {
        edit = {
          strategy = 'inline_edit',
          system = [[
You are an AI coding assistant.
You MUST produce a valid unified diff.
Wrap the final output in:

<CC_EDIT>
...diff here...
</CC_EDIT>

You MUST NOT output explanations or natural language.
          ]],
          prompt = [[
Apply the requested changes to the selected code. Return ONLY an inline
unified diff wrapped in <CC_EDIT> ... </CC_EDIT>.
          ]],
        },

        explain = {
          strategy = 'chat',
          system = 'You are a senior software engineer. Do NOT output diffs.',
          prompt = 'Explain the selected code clearly and concisely.',
        },

        review = {
          strategy = 'chat',
          system = 'You are a strict code reviewer. Do NOT output diffs.',
          prompt = 'Review the selected code for bugs and improvements.',
        },
      },

      ----------------------------------------------------------------------
      -- INTERACTIONS
      ----------------------------------------------------------------------
      interactions = {
        chat = {
          adapter = {
            name = 'qgenie',
            model = DEFAULT_MODEL,
          },
          window = { layout = 'vertical' },

          keymaps = {
            change_model = {
              modes = { n = 'gm' },
              description = 'Change Model',
              callback = function(chat)
                require('codecompanion.interactions.chat.keymaps.change_adapter').select_model(chat)
              end,
            },
          },
        },

        inline = { adapter = 'qgenie' },
        cmd = { adapter = 'qgenie' },
      },

      ----------------------------------------------------------------------
      -- ADAPTERS (QGenie)
      ----------------------------------------------------------------------
      adapters = {
        acp = { opts = { show_defaults = false } },

        http = {
          opts = {
            show_defaults = false,
            cache_models_for = 3600,
            show_model_choices = true,
          },

          qgenie = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              env = {
                api_key = os.getenv 'QGENIE_API_KEY',
                url = 'https://qgenie-api.qualcomm.com',
              },
              schema = {
                model = { default = DEFAULT_MODEL },
              },
            })
          end,
        },
      },

      extensions = {
        spinner = { opts = { style = 'cursor-relative' } },
      },
    },

    ------------------------------------------------------------------------
    -- KEYMAPS
    ------------------------------------------------------------------------
    config = function(_, opts)
      local cc = require 'codecompanion'
      cc.setup(opts)

      -- Chat
      vim.keymap.set('n', '<leader>cc', function()
        cc.chat()
      end, { desc = 'CodeCompanion Chat' })

      -- Chat with buffer context
      vim.keymap.set('n', '<leader>cb', function()
        cc.chat { with_context = true }
      end, { desc = 'Chat with Buffer Context' })

      -- Inline edit (diff)
      vim.keymap.set('v', '<leader>ci', function()
        cc.inline { preset = 'edit' }
      end, { desc = 'Inline Edit' })

      -- Explain code
      vim.keymap.set('v', '<leader>ce', function()
        cc.inline { preset = 'explain' }
      end, { desc = 'Explain Code' })

      -- Review code
      vim.keymap.set('v', '<leader>cr', function()
        cc.inline { preset = 'review' }
      end, { desc = 'Review Code' })

      -- CLI agent: floating terminal running claude
      vim.keymap.set('n', '<leader>ca', function()
        local buf = vim.api.nvim_create_buf(false, true)
        local width = math.floor(vim.o.columns * 0.95)
        local height = math.floor(vim.o.lines * 0.95)
        vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          col = math.floor((vim.o.columns - width) / 2),
          row = math.floor((vim.o.lines - height) / 2),
          style = 'minimal',
          border = 'rounded',
        })
        vim.fn.termopen 'claude'
        vim.cmd 'startinsert'
      end, { desc = 'Run Claude CLI Agent' })

      -- Toggle main UI
      vim.keymap.set('n', '<leader>ct', function()
        cc.toggle()
      end, { desc = 'Toggle CodeCompanion Window' })

      -- Repeat last action
      vim.keymap.set('n', '<leader>c.', function()
        cc.repeat_last()
      end, { desc = 'Repeat Last AI Action' })
    end,
  },
}
