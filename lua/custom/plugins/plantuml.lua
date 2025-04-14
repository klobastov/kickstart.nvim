return {
  'https://gitlab.com/itaranto/plantuml.nvim',
  version = '*',
  opts = {
    renderer = {
      type = 'text',
      options = {
        split_cmd = 'split', -- Allowed values: 'split', 'vsplit'.
      },
      -- type = 'image',
      -- options = {
      --   prog = 'feh',
      --   dark_mode = false,
      --   format = 'png', -- Allowed values: nil, 'png', 'svg'.
      -- },
      -- type = 'imv',
      -- options = {
      --   dark_mode = false,
      --   format = 'png', -- Allowed values: nil, 'png', 'svg'.
      -- },
    },
    render_on_write = true, -- Set to false to disable auto-rendering.
  },
  config = function(_, opts)
    require('plantuml').setup(opts)
  end,
}
