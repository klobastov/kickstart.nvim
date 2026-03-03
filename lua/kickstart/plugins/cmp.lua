return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter' },
    dependencies = {
      -- 'hrsh7th/cmp-nvim-lsp',
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.4',
        build = 'make install_jsregexp',
      },
      'saadparwaiz1/cmp_luasnip',

      'f3fora/cmp-spell',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      { 'tzachar/cmp-fuzzy-path', dependencies = { 'tzachar/fuzzy.nvim' } },
      -- { 'tzachar/cmp-fuzzy-buffer', dependencies = { 'tzachar/fuzzy.nvim' } },
    },

    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local kind_icons = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = '',
        Variable = '',
        Class = '',
        Interface = '',
        Module = '',
        Property = '',
        Unit = '',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = '',
      }

      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,preview,noselect',
          autocomplete = { cmp.TriggerEvent.TextChanged },
        },

        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        },

        view = {
          docs = {
            auto_open = true,
          },
        },

        sources = {
          { name = 'codecompanion', group_index = 0 },
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp', group_index = 2, priority = 10 },
          -- { name = 'path', max_item_count = 4, priority = 7 },
          { name = 'fuzzy_path', max_item_count = 4, priority = 7 },
          {
            name = 'buffer',
            max_item_count = 4,
            priority = 9,
            option = {
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
          {
            name = 'spell',
            max_item_count = 4,
            priority = 8,
            option = {
              keyword_pattern = [[\k\+]],
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
              preselect_correct_word = false,
            },
          },
        },

        formatting = {
          expandable_indicator = true,
          fields = { 'abbr', 'kind', 'menu' },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) or ''
            vim_item.menu = ({
              nvim_lua = '[NVim Lua]',
              buffer = '[Buffer]',
              path = '[Path]',
              spell = '[Spell]',
            })[entry.source.name]

            if entry.source.name == 'nvim_lsp' then
              local lspserver_name = nil
              pcall(function()
                lspserver_name = entry.source.source.client.name
                vim_item.menu = lspserver_name
              end)
            end
            return vim_item
          end,
        },

        mapping = cmp.mapping.preset.insert {
          ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),
          ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
          ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item()),
          ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item()),

          -- jump to next porition after modify or complete
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end),
          -- s for switching parameters in function after complete
          -- c for search command line
          -- i for default writing code and vim command line

          -- jump to previous position after modify or complete
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end),

          -- abort completion in code and vim command line
          ['<C-e>'] = cmp.mapping(cmp.mapping.abort()),

          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete()),

          -- confirm completion
          ['<CR>'] = cmp.mapping(cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace }),
        },

        preselect = cmp.PreselectMode.None,
      }

      cmp.setup.filetype('lua', {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'spell' },
        },
      })

      cmp.setup.filetype('sql', {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })

      cmp.setup.filetype('help', {
        window = {
          documentation = nil,
        },
      })

      cmp.setup.filetype('php', {
        sources = {
          { name = 'codecompanion' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'fuzzy_path' },
          { name = 'spell' },
        },
      })
    end,
  },
  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    config = function()
      local cmp = require 'cmp'

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
          { name = 'buffer' },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          -- { name = 'path', option = { trailing_slash = true } },
          { name = 'fuzzy_path' },
        }, {
          { name = 'cmdline' },
        }),
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
