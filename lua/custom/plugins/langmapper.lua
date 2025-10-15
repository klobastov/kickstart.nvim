return {
  'Wansmer/langmapper.nvim',
  lazy = false,
  enabled = true,
  config = function()
    require('langmapper').setup { --[[ your config ]]
    }
  end,
}
