return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
      },
      'saadparwaiz1/cmp_luasnip',
    },

    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local icons = require 'mini.icons'
      local context = require 'cmp.config.context'

      -- per-filetype config
      cmp.setup.filetype('lua', {
        { name = 'nvim_lsp' },
        { name = 'lazydev', group_index = 0 },
        {
          name = 'buffer',
          option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
        },

        { name = 'luasnip' },
        {
          name = 'snippets',
          filter = function()
            return not context.in_syntax_group 'Comment' or not context.in_treesitter_capture 'comment'
          end,
        },
        -- { name = "treesitter" },
        { name = 'path', option = { trailing_slash = true } },
      })

      cmp.setup.filetype({ 'markdown', 'text', 'quarto', 'qmd' }, {
        sources = {
          {
            name = 'buffer',
            option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
          },
          { name = 'nvim_lsp' },
          { name = 'snippets' },
          { name = 'path', option = { trailing_slash = true } },
          { name = 'obsidian' },
          { name = 'obsidian_new' },
          { name = 'obsidian_tags' },
        },
      })

      cmp.setup.filetype('help', {
        window = {
          documentation = nil,
        },
      })

      cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
        sources = {
          { name = 'nvim_lsp' },
          -- { name = "treesitter" },
          { name = 'snippets' },
          { name = 'buffer' },
        },
      })

      cmp.setup.filetype('gitcommit', {
        sources = {
          { name = 'gh_issues' },
          { name = 'snippets' },
        },
      })

      -- phpactor doesnot support dap completion
      -- check with vim command bellow
      -- :lua= require("dap").session().capabilities.supportsCompletionsRequest
      cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
        sources = {
          { name = 'dap' },
        },
      })

      cmp.setup.filetype('php', {
        sources = {
          { name = 'nvim_lsp' },
          {
            name = 'buffer',
            option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
          },
          { name = 'snippets' },
          { name = 'path', option = { trailing_slash = true } },
        },
      })

      cmp.setup {
        completion = {
          completeopt = 'menuone,noselect,preview',
          -- disable auto enable when typing
          autocomplete = false,
        },

        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        },

        view = {
          docs = {
            auto_open = false,
          },
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        enabled = function()
          return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
        end,

        formatting = {
          expandable_indicator = true,
          fields = { 'abbr', 'kind', 'menu' },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', icons.get('lsp', vim_item.kind), vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              snippets = '[Snip]',
              buffer = '[Buf]',
              path = '[Path]',
            })[entry.source.name]

            return vim_item
          end,
        },

        mapping = cmp.mapping.preset.insert {
          ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
          ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
          ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
          ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),

          -- jump to next porition after modify or complete
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 'c', 's' }),
          -- s for switchin params in function after complete
          -- c for search command line
          -- i for default writing code and vim command line

          -- jump to prew porition after modify or complete
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 'c', 's' }),

          -- abort completion in code and vim command line
          ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 's', 'c' }),

          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 's', 'c' }),

          -- confirm completion
          ['<CR>'] = cmp.mapping(cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace }, { 'i', 's', 'c' }),

          ['<C-g>'] = function()
            if not cmp.visible_docs() then
              cmp.open_docs()
            else
              cmp.close_docs()
            end
          end,
        },

        preselect = cmp.PreselectMode.Item,

        experimental = {
          ghost_text = {
            enable = false,
            hl_group = 'Comment',
          },
        },
      }
    end,
  },
  { 'hrsh7th/cmp-nvim-lsp', event = 'LspAttach' },
  { 'hrsh7th/cmp-buffer', event = 'BufRead' },
  { 'hrsh7th/cmp-path', event = 'BufRead' },
  { 'rcarriga/cmp-dap', ft = { 'dap-repl', 'dapui_watches', 'dapui_hover' } },
  {
    'garymjr/nvim-snippets',
    event = 'InsertEnter',
    -- dependencies = { "kevinm6/snippets", dev = true },
    opts = {
      -- TODO on nvim-0.11 => set when activating built-in completion (w/o nvim-cmp)
      -- o.create_cmp_source = false
      extended_filetypes = {
        typescript = { 'javascript', 'tsdoc' },
        javascript = { 'jsdoc' },
        html = { 'css', 'javascript' },
        lua = { 'luadoc', 'nvim_lua' },
        python = { 'python-docstring' },
        java = { 'javadoc', 'java-testing' },
        sh = { 'shelldoc' },
        php = { 'phpdoc' },
        ruby = { 'rdoc' },
        quarto = { 'quarto', 'markdown', 'md' },
        qmd = { 'quarto', 'md', 'markdown' },
        rmarkdown = { 'markdown' },
      },
      search_paths = { vim.env.HOME .. '/dev/snippets' },
    },
  },
  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    config = function()
      local cmp = require 'cmp'

      cmp.setup.cmdline('/', {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        sources = cmp.config.sources {
          { name = 'buffer', length = 2 },
          -- { name = "treesitter", length = 3 },
        },
      })

      cmp.setup.cmdline(':', {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path', option = { trailing_slash = true }, length = 2 },
        }, {
          { name = 'cmdline', length = 3 },
        }),
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
