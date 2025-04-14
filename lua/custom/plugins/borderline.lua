return {
  'mikesmithgh/borderline.nvim',
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('borderline').setup {
      border = 'single',
      enabled = true,
      border_styles = {
        error = {
          { '┌', 'NvimInternalError' },
          { '─', 'NvimInternalError' },
          { '┐', 'NvimInternalError' },
          { '│', 'NvimInternalError' },
          { '┘', 'NvimInternalError' },
          { '─', 'NvimInternalError' },
          { '└', 'NvimInternalError' },
          { '│', 'NvimInternalError' },
        },
      },
    }
  end,
}
