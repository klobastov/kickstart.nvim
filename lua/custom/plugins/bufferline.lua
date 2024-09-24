return {
  {
    'akinsho/bufferline.nvim',
    dependencies = {
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local b = require 'bufferline'

      b.setup {
        options = {
          mode = 'buffers', -- set to "tabs" to only show tabpages instead
          show_buffer_close_icons = false,
          always_show_bufferline = false,
          numbers = 'ordinal',
          separator_style = { '', '' },
          max_name_length = 22,
          max_prefix_length = 18, -- prefix used when a buffer is de-duplicate
          tab_size = 22,
          move_wraps_at_ends = true,
          hover = {
            enabled = false,
          },
        },
      }
    end,
  },
}
