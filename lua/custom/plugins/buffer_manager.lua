return {
  'j-morano/buffer_manager.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- {
    --   'ghillb/cybu.nvim',
    --   opts = {
    --     style = {
    --       path = 'relative', -- absolute, relative, tail (filename only),
    --       path_abbreviation = 'none', -- none, shortened
    --       padding = 1,
    --       hide_buffer_id = false,
    --     },
    --     display_time = 1200,
    --     exclude = {
    --       'neo-tree',
    --       'qf',
    --       'neo-term',
    --     },
    --   },
    -- },
  },
  opts = {
    -- order_buffers = 'bufnr',
    select_menu_item_commands = {
      v = {
        key = '<C-v>',
        command = 'vsplit',
      },
      h = {
        key = '<C-h>',
        command = 'split',
      },
    },
    focus_alternate_buffer = false,
    short_file_names = false,
    short_term_names = false,
    show_depth = true,
    width = 130,
    height = 12,
    loop_nav = false,
    highlight = 'Normal:BufferManagerBorder',
    win_extra_options = {
      winhighlight = 'Normal:BufferManagerNormal',
    },
    format_function = nil,
    order_buffers = nil,
    show_indicators = nil,
  },
  config = function(_, opts)
    require('buffer_manager').setup(opts)

    -- vim.api.nvim_command [[
    --   autocmd FileType buffer_manager vnoremap J :m '>+1<CR>gv=gv
    --   autocmd FileType buffer_manager vnoremap K :m '<-2<CR>gv=gv
    -- ]]
  end,
  keys = {
    {
      '<C-c>',
      function()
        require('buffer_manager.ui').toggle_quick_menu()

        -- wait for the menu to open
        -- vim.defer_fn(function()
        --   vim.fn.feedkeys '/'
        -- end, 50)
      end,
      desc = 'Toggle buffer manager',
      mode = 'n',
    },
    {
      '<Tab>',
      function()
        require('buffer_manager.ui').nav_next()
        -- require('cybu').cycle 'next'
      end,
      desc = 'Next buffer',
      mode = 'n',
    },
    {
      '<S-Tab>',
      function()
        require('buffer_manager.ui').nav_prev()
        -- require('cybu').cycle 'prev'
      end,
      desc = 'Prev buffer',
      mode = 'n',
    },
  },
}
