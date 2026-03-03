return {
  'olimorris/codecompanion.nvim',
  enabled = true,
  branch = 'main',
  dependencies = {
    { 'nvim-mini/mini.diff', version = '*' },
    'nvim-lua/plenary.nvim',
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    'ravitemer/codecompanion-history.nvim',
    { 'cairijun/codecompanion-agentskills.nvim' },
    {
      'Davidyz/VectorCode',
      version = '*',
      build = 'uv tool upgrade vectorcode',
      cond = function()
        return vim.fn.executable 'vectorcode' == 1
      end,
      opts = {
        {
          n_query = 1, -- number of retrieved documents
          notify = true, -- enable notifications
          timeout_ms = 5000, -- timeout in milliseconds for the query operation.
          exclude_this = true, -- exclude the buffer from which the query is called.
          async_backend = 'lsp', -- or "lsp"
        },
      },
    },
  },
  config = function()
    require('codecompanion').setup {
      extensions = {
        agentskills = {
          opts = {
            paths = {
              { '.opencode/skills', recursive = true },
            },
          },
        },
        vectorcode = {
          opts = {
            tool_group = {
              -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
              enabled = false,
              -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
              -- if you use @vectorcode_vectorise, it'll be very handy to include
              -- `file_search` here.
              extras = { 'file_search' },
              collapse = false, -- whether the individual tools should be shown in the chat
            },
            tool_opts = {
              ['*'] = {},
              ls = {},
              vectorise = {},
              query = {
                max_num = { chunk = -1, document = -1 },
                default_num = { chunk = 50, document = 10 },
                include_stderr = false,
                use_lsp = false,
                no_duplicate = true,
                chunk_mode = false,
                summarise = {
                  enabled = true,
                  adapter = 'opencode',
                  query_augmented = true,
                },
              },
              files_ls = {},
              files_rm = {},
            },
          },
        },
        history = {
          enabled = false,
          opts = {
            dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion_chats.json',
          },
        },
      },

      opts = {
        log_level = 'DEBUG',
        language = 'Russian',
        title_generation_opts = {
          refresh_every_n_prompts = 0,
        },
        per_project_config = {
          files = {
            '.codecompanion.lua',
          },
        },
      },

      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = 'Prompt ', -- Prompt used for interactive LLM calls
          provider = 'telescope', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_preset_actions = true, -- Show the preset actions in the action palette?
            show_preset_prompts = true, -- Show the preset prompts in the action palette?
            title = 'CodeCompanion actions', -- The title of the action palette
          },
          chat = {
            auto_scroll = false,
          },
        },

        diff = {
          enabled = true,
          word_highlights = {
            additions = true,
            deletions = true,
          },
          provider = 'mini_diff',
        },

        chat = {
          -- show_references = true,
          -- show_header_separator = false,
          show_settings = false,
          show_reasoning = false,
          fold_context = false,
        },
      },

      interactions = {
        chat = {
          roles = {
            user = 'klobastov',
          },
          variables = {},
          adapter = 'opencode',
          tool_opts = {
            ['*'] = {
              auto_execute = true,
            },
          },
          tools = {
            auto_submit_errors = true, -- Send any errors to the LLM automatically?
            auto_submit_success = true, -- Send any successful output to the LLM automatically?
            opts = {
              -- xml = {
              --   enabled = true,
              --   tool_call_tag = 'tool',
              --   tool_result_tag = 'tool_result',
              -- },
              completion_provider = 'cmp', -- blink|cmp|coc|default
              default_tools = {
                'agent_skills',
              },
            },
          },
          -- opts = {
          --   ---Decorate the user message before it's sent to the LLM
          --   ---@param message string
          --   ---@param adapter CodeCompanion.Adapter
          --   ---@param context table
          --   ---@return string
          --   prompt_decorator = function(message, adapter, context)
          --     return string.format([[<prompt>%s</prompt>]], message)
          --   end,
          -- },
        },

        -- background = {
        --   chat = {
        --     opts = {
        --       enabled = true,
        --     },
        --   },
        -- },
      },

      adapters = {
        acp = {
          opencode = function()
            return require('codecompanion.adapters').extend('opencode', {
              timeout = 30000,
              parameters = {
                protocolVersion = 1,
                clientCapabilities = {
                  fs = { readTextFile = true, writeTextFile = true },
                  terminal = false,
                  tools = true,
                },
                clientInfo = {
                  name = 'CodeCompanion.nvim',
                  version = '1.0.0',
                },
              },
            })
          end,
        },
      },
    }
    vim.api.nvim_set_keymap('n', '<leader>cc', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<leader>cc', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>ci', '<cmd>CodeCompanion<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<leader>ci', '<cmd>CodeCompanion<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>cs', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<leader>ca', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<leader>ce', '<cmd>CodeCompanionChat Explain in Russian<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<leader>cd', '<cmd>CodeCompanionChat Document in Russian<cr>', { noremap = true, silent = true })
  end,
}
