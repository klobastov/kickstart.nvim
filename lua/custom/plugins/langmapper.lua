return {
  'Wansmer/langmapper.nvim',
  lazy = false,
  enabled = false,
  priority = 1, -- High priority is needed if you will use `autoremap()`
  config = function()
    require('langmapper').setup { --[[ your config ]]
    }
  end,
}
