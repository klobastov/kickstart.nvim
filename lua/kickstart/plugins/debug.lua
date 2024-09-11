return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- nvim-dap features
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      {
        '<leader>db',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Breakpoint Condition',
      },
      {
        '<leader>dd',
        function()
          dap.toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
      },
      {
        '<F5>',
        function()
          dap.continue()
        end,
        desc = 'Start/Continue',
      },
      {
        '<F8>',
        function()
          dap.run_to_cursor()
        end,
        desc = 'Run to Cursor',
      },
      {
        '<F1>',
        function()
          dap.step_into()
        end,
        desc = 'Step Into',
      },
      {
        '<F10>',
        function()
          dap.run_last()
        end,
        desc = 'Run Last',
      },
      {
        '<F2>',
        function()
          dap.step_out()
        end,
        desc = 'Step Out',
      },
      {
        '<F3>',
        function()
          dap.step_over()
        end,
        desc = 'Step Over',
      },
      {
        '<leader>dr',
        function()
          dap.repl.toggle()
        end,
        desc = 'Toggle REPL',
      },
      {
        '<F7>',
        function()
          dapui.toggle()
        end,
        desc = 'See last session result',
      },
      {
        '<F4>',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = 'Widgets hover',
      },
      unpack(keys),
    }
  end,
  init = function()
    vim.api.nvim_create_autocmd({ 'FileType' }, {
      pattern = 'dap-float',
      callback = function()
        vim.keymap.set('n', '<ESC>', '<cmd>close<cr>', { buffer = true, silent = true })
      end,
    })
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    require('nvim-dap-virtual-text').setup {
      enabled = true,
    }
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,
      handlers = {
        function(config)
          -- all sources with no handler get passed here

          -- Keep original functionality
          require('mason-nvim-dap').default_setup(config)
        end,
        php = function(config)
          config.adapters = {
            type = 'executable',
            command = 'node',
            args = { vim.fn.stdpath 'data' .. '/mason/packages/php-debug-adapter/extension/out/phpDebug.js' },
          }
          config.configurations = {
            {
              type = 'php',
              prepl_lang = 'php',
              request = 'launch',
              name = 'Debug current script locally',
              port = 9003,
              hostname = '0.0.0.0',
              log = false,
              program = '${file}',
              cwd = '${fileDirname}',
              runtimeArgs = { '-dxdebug.start_with_request=yes' },
              env = {
                XDEBUG_MODE = 'debug,develop',
                XDEBUG_CONFIG = 'client_port=${port}',
              },
              pathMappings = {
                ['${workspaceFolder}'] = '${workspaceFolder}',
              },
            },
            {
              type = 'php',
              prepl_lang = 'php',
              request = 'launch',
              name = 'Debug current script with args locally',
              port = 9003,
              hostname = '0.0.0.0',
              log = false,
              program = '${file}',
              cwd = '${fileDirname}',
              runtimeArgs = { '-dxdebug.start_with_request=yes' },
              env = {
                XDEBUG_MODE = 'debug,develop',
                XDEBUG_CONFIG = 'client_port=${port}',
              },
              args = function()
                local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
                args = type(args) == 'table' and args or {}
                config = vim.deepcopy(config)
                ---@cast args string[]
                local new_args = vim.fn.input('Run with args: ', table.concat(args, ' ')) --[[@as string]]
                return vim.split(vim.fn.expand(new_args) --[[@as string]], ' ')
              end,
              pathMappings = {
                ['${workspaceFolder}'] = '${workspaceFolder}',
              },
            },
            {
              type = 'php',
              prepl_lang = 'php',
              request = 'launch',
              name = 'Run current script locally',
              port = 9003,
              cwd = '${fileDirname}',
              program = '${file}',
              runtimeExecutable = 'php',
              pathMappings = {
                ['${workspaceFolder}'] = '${workspaceFolder}',
              },
            },
            {
              type = 'php',
              prepl_lang = 'php',
              request = 'launch',
              name = 'Run current script with args locally',
              port = 9003,
              cwd = '${fileDirname}',
              program = '${file}',
              runtimeExecutable = 'php',
              args = function()
                local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
                args = type(args) == 'table' and args or {}
                config = vim.deepcopy(config)
                ---@cast args string[]
                local new_args = vim.fn.input('Run with args: ', table.concat(args, ' ')) --[[@as string]]
                return vim.split(vim.fn.expand(new_args) --[[@as string]], ' ')
              end,
              pathMappings = {
                ['${workspaceFolder}'] = '${workspaceFolder}',
              },
            },
          }
          require('mason-nvim-dap').default_setup(config)
        end,
      },

      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'php',
      },
    }

    dapui.setup {
      force_buffers = true,
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      expand_lines = vim.fn.has 'nvim-0.7' == 1,
      controls = {
        -- Requires Neovim nightly (or 0.8 when released)
        enabled = true,
        -- Display controls in this element
        element = 'repl',
        icons = {
          pause = '',
          play = '',
          step_into = '↘️',
          step_over = '➡️',
          step_out = '↖️',
          step_back = '',
          run_last = '↻',
          terminate = '□',
        },
      },
      element_mappings = {
        scopes = {
          edit = 'e',
          repl = 'r',
        },
        watches = {
          edit = 'e',
          repl = 'r',
        },
        stacks = {
          open = 'o',
        },
        breakpoints = {
          open = 'o',
          toggle = 't',
        },
      },
      layouts = {
        {
          elements = {
            'scopes',
            'stacks',
            'watches',
          },
          size = 0.2, -- 40 columns
          position = 'left',
        },
        {
          elements = {
            'repl',
            'breakpoints',
          },
          size = 0.3,
          position = 'bottom',
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single', -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      windows = { indent = 1 },
      render = {
        indent = 1,
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
