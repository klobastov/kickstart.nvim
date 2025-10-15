return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  -- Optional dependency
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    require('nvim-autopairs').setup {
      map_cr = false,
    }
    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

    -- Custom rules
    local Rule = require 'nvim-autopairs.rule'
    local npairs = require 'nvim-autopairs'
    npairs.add_rules {
      Rule('-', '>', 'php'):with_move(function(opts)
        return opts.char == '-'
      end),
    }
  end,
}
