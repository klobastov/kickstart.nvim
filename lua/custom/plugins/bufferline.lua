return {
  {
    'akinsho/bufferline.nvim',
    enabled = false,
    dependencies = {
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { 'famiu/bufdelete.nvim' },
    },
    config = function()
      local b = require 'bufferline'

      b.setup {
        options = {
          close_command = require('bufdelete').bufdelete,
          diagnostics_update_on_event = true,
          mode = 'buffers', -- set to "tabs" to only show tabpages instead
          numbers = 'ordinal',
          separator_style = 'thick',
          persist_buffer_sort = false,
          show_tab_indicators = false,
          custom_filter = function(buf_number)
            if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
              return true
            end
          end,
          offsets = {
            {
              filetype = 'NeoTree',
              text_align = 'left',
              separator = true,
            },
          },
          sort_by = 'insert_after_current',
        },
      }
    end,
  },
}
