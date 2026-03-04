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
    -- {
    --   'ravitemer/mcphub.nvim',
    --   dependencies = {
    --     'nvim-lua/plenary.nvim',
    --   },
    --   build = 'npm install -g mcp-hub@latest',
    --   config = function()
    --     require('mcphub').setup {
    --       port = 3000, -- Port for the mcp-hub Express server
    --       config = vim.fn.expand '~/.config/nvim/mcpservers.json',
    --       log = {
    --         level = vim.log.levels.WARN, -- Adjust verbosity (DEBUG, INFO, WARN, ERROR)
    --         to_file = true, -- Log to ~/.local/state/nvim/mcphub.log
    --       },
    --       on_ready = function()
    --         vim.notify('MCP Hub backend server is initialized and ready.', vim.log.levels.INFO)
    --       end,
    --     }
    --   end,
    -- },
    -- {
    --   'Davidyz/VectorCode',
    --   version = '*',
    --   build = 'uv tool upgrade vectorcode',
    --   cond = function()
    --     return vim.fn.executable 'vectorcode' == 1
    --   end,
    --   opts = {
    --     {
    --       n_query = 1, -- number of retrieved documents
    --       notify = true, -- enable notifications
    --       timeout_ms = 5000, -- timeout in milliseconds for the query operation.
    --       exclude_this = true, -- exclude the buffer from which the query is called.
    --       async_backend = 'lsp', -- or "lsp"
    --     },
    --   },
    -- },
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
        -- mcphub = {
        --   callback = 'mcphub.extensions.codecompanion',
        --   opts = {
        --     make_vars = true,
        --     make_slash_commands = true,
        --     show_result_in_chat = true,
        --   },
        -- },
        -- vectorcode = {
        --   opts = {
        --     tool_group = {
        --       enabled = true,
        --       -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
        --       -- if you use @vectorcode_vectorise, it'll be very handy to include
        --       -- `file_search` here.
        --       extras = { 'file_search' },
        --       collapse = false, -- whether the individual tools should be shown in the chat
        --     },
        --   },
        -- },
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
          prompt = 'Prompt ',
          provider = 'telescope',
          opts = {
            show_preset_actions = true,
            show_preset_prompts = true,
            title = 'CodeCompanion actions',
          },
          chat = {
            auto_scroll = true,
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
          show_reasoning = true,
          fold_context = true,
        },
      },

      interactions = {
        -- inline = {
        --   adapter = 'vllm',
        -- },
        --
        -- cmd = {
        --   adapter = 'opencode_acp',
        -- },
        --
        -- agent = {
        --   adapter = 'opencode_acp',
        -- },
        --
        chat = {
          roles = {
            user = 'klobastov',
          },
          variables = {},
          -- adapter = 'vllm',
          adapter = 'opencode_acp',
          tools = {
            --             groups = {
            --               ['qwen_agent'] = {
            --                 description = 'Agent optimized for Qwen3',
            --                 system_prompt = [[
            -- <instructions>
            -- You are an AI coding assistant using Qwen3 model.
            -- When using tools, you MUST output ONLY valid JSON in ONE LINE.
            --
            -- CRITICAL RULES:
            -- 1. All tool calls must be SINGLE LINE JSON
            -- 2. NO line breaks or indentation
            -- 3. NO explanatory text before/after
            -- 4. Format: {"name":"tool_name","arguments":{"param":"value"}}
            --
            -- Example: {"name":"run_command","arguments":{"cmd":"ls -la","flag":null}}
            --
            -- Available tools:
            -- - run_command: execute shell commands
            -- - read_file: read files
            -- - create_file: create new files
            -- - grep_search: search text
            -- - file_search: find files
            -- - insert_edit_into_file: edit files
            -- </instructions>
            -- ]],
            --                 tools = {
            --                   'run_command',
            --                   'read_file',
            --                   'create_file',
            --                   'grep_search',
            --                   'file_search',
            --                   'insert_edit_into_file',
            --                 },
            --               },
            --             },
            opts = {
              timeout = 30000,
              completion_provider = 'cmp',
            },

            mcphub = {
              callback = function()
                return require 'mcphub.extensions.codecompanion'
              end,
              opts = {
                -- If true, CodeCompanion will ask for approval before executing the MCP tool call
                -- requires_approval = true,
                -- Optional: Pass parameters like temperature to the underlying LLM if the chat strategy supports it
                -- temperature = 0.7,
              },
            },
          },
        },

        background = {
          adapter = 'vllm',
          chat = {
            opts = {
              enabled = false,
            },
          },
        },
      },

      adapters = {
        -- http = {
        --   opts = {
        --     show_presets = false,
        --     show_model_choices = false,
        --     proxy = 'http://localhost:7999',
        --   },
        --   vllm = function()
        --     return require('codecompanion.adapters').extend('openai_compatible', {
        --       name = 'vllm', -- Внутреннее имя
        --       formatted_name = 'vLLM', -- Отображаемое имя
        --       env = {
        --         url = 'http://localhost:8000',
        --         chat_url = '/v1/chat/completions',
        --       },
        --       -- Параметры запросов по умолчанию
        --       parameters = {
        --         stream = true,
        --         model = 'Qwen3-Coder-30B-A3B-Instruct',
        --         -- temperature = 0.1,
        --         max_tokens = 20000,
        --         -- top_p = 0.1,
        --       },
        --
        --       -- Схема параметров
        --       schema = {
        --         model = {
        --           default = 'Qwen3-Coder-30B-A3B-Instruct',
        --         },
        --         -- temperature = {
        --         --   default = 0.7,
        --         --   range = { 0, 2 },
        --         -- },
        --         max_tokens = {
        --           default = 20000,
        --           range = { 1, 20000 },
        --         },
        --       },
        --       headers = {
        --         ['Content-Type'] = 'application/json',
        --       },
        --       -- Таймаут
        --       timeout = 30000,
        --     })
        --   end,
        -- },
        acp = {
          opencode_acp = function()
            return require('codecompanion.adapters').extend('opencode', {
              defaults = {
                timeout = 60000,
              },

              parameters = {
                protocolVersion = 1,
                clientCapabilities = {
                  fs = { readTextFile = true, writeTextFile = true },
                  terminal = false,
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
