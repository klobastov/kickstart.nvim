local lspkind_comparator = function(conf)
  local lsp_types = require('cmp.types').lsp
  return function(entry1, entry2)
    if entry1.source.name ~= 'nvim_lsp' then
      if entry2.source.name == 'nvim_lsp' then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
    -- if kind1 == 'Variable' and entry1:get_completion_item().label:match '%w*=' then
    --   kind1 = 'Parameter'
    -- end
    -- if kind2 == 'Variable' and entry2:get_completion_item().label:match '%w*=' then
    --   kind2 = 'Parameter'
    -- end

    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end

local label_comparator = function(entry1, entry2)
  return entry1.completion_item.label < entry2.completion_item.label
end

return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter' },
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
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'rcarriga/cmp-dap',
      {
        'MattiasMTS/cmp-dbee',
        enabled = false,
        dependencies = {
          { 'kndndrj/nvim-dbee' },
        },
        ft = 'sql', -- optional but good to have
        opts = {}, -- needed
      },
      'f3fora/cmp-spell',
    },

    config = function()
      local cmp = require 'cmp'
      local compare = require 'cmp.config.compare'
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
        enabled = function()
          return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
        end,
        completion = {
          -- completeopt = 'menu,menuone,noinsert,noselect',
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

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },

        sources = {
          { name = 'lazydev', group_index = 0 },
          {
            name = 'luasnip',
            group_index = 2,
            option = {
              use_show_condition = true,
              show_autosnippets = true,
            },
          },
          { name = 'nvim_lsp', group_index = 2, priority = 10 },
          { name = 'path', max_item_count = 4, priority = 7 },
          { name = 'buffer', max_item_count = 4, priority = 9 },
          {
            name = 'spell',
            max_item_count = 4,
            priority = 8,
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
              preselect_correct_word = false,
            },
          },
          { name = 'cmp-dbee' },
          { name = 'dap' },
        },
        -- sorting = {
        --   priority_weight = 1,
        --   comparators = {
        --     -- compare.recently_used,
        --     -- lspkind_comparator {
        --     --   kind_priority = {
        --     --     Parameter = 14,
        --     --     Variable = 12,
        --     --     Field = 11,
        --     --     Property = 11,
        --     --     Constant = 10,
        --     --     Keyword = 15,
        --     --     Enum = 10,
        --     --     EnumMember = 10,
        --     --     Event = 10,
        --     --     Function = 10,
        --     --     Method = 10,
        --     --     Operator = 10,
        --     --     Reference = 10,
        --     --     Struct = 10,
        --     --     File = 8,
        --     --     Folder = 8,
        --     --     Class = 5,
        --     --     Color = 5,
        --     --     Module = 5,
        --     --     Constructor = 3,
        --     --     Interface = 5,
        --     --     TypeParameter = 5,
        --     --     Unit = 1,
        --     --     Value = 1,
        --     --     Text = 0,
        --     --     Snippet = 9,
        --     --   },
        --     -- },
        --     label_comparator,
        --     compare.exact,
        --     -- compare.scopes,
        --     -- compare.sort_text,
        --   },
        -- },
        formatting = {
          expandable_indicator = true,
          fields = { 'abbr', 'kind', 'menu' },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) or ''
            vim_item.menu = ({
              -- nvim_lsp = '[LSP]',
              nvim_lua = '[NVim Lua]',
              luasnip = '[LuaSnip]',
              buffer = '[Buf]',
              path = '[Path]',
              spell = '[Spell]',
            })[entry.source.name]

            if entry.source.name == 'nvim_lsp' then
              -- Display which LSP servers this item came from.
              local lspserver_name = nil
              pcall(function()
                lspserver_name = entry.source.source.client.name
                vim_item.menu = lspserver_name
              end)
            end
            return vim_item
          end,
        },
        -- experimental = {
        --   ghost_text = {
        --     enable = false,
        --     hl_group = 'Comment',
        --   },
        -- },
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

          ['<C-g>'] = function()
            if not cmp.visible_docs() then
              cmp.open_docs()
            else
              cmp.close_docs()
            end
          end,
        },

        -- preselect = cmp.PreselectMode.Item,
        preselect = cmp.PreselectMode.None,
      }

      cmp.setup.filetype('lua', {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'spell' },
        },
      })

      cmp.setup.filetype('sql', {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'cmp-dbee' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })

      cmp.setup.filetype('help', {
        window = {
          documentation = nil,
        },
      })

      -- phpactor doesnot support dap completion
      -- check with vim command bellow
      -- :lua= require("dap").session().capabilities.supportsCompletionsRequest
      cmp.setup.filetype({ 'dap-repl', 'Commentdapui_watches', 'dapui_hover' }, {
        sources = {
          { name = 'dap' },
        },
      })

      cmp.setup.filetype('php', {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'spell' },
        },
      })
    end,
  },
  -- {
  --   'garymjr/nvim-snippets',
  --   event = 'InsertEnter',
  --   -- dependencies = { "kevinm6/snippets", dev = true },
  --   opts = {
  --     -- TODO on nvim-0.11 => set when activating built-in completion (w/o nvim-cmp)
  --     -- o.create_cmp_source = false
  --     extended_filetypes = {
  --       lua = { 'luadoc', 'nvim_lua' },
  --       php = { 'phpdoc' },
  --     },
  --     search_paths = { vim.env.HOME .. '/dev/snippets' },
  --   },
  -- },
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
          { name = 'path', option = { trailing_slash = true } },
        }, {
          { name = 'cmdline' },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
