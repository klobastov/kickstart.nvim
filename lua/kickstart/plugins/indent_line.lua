return {
  { -- Add indentation guides even on blank lines
    enabled = false,
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    opts = function()
      return {
        indent = {
          char = '│',
          tab_char = '╏',
        },
        whitespace = {
          remove_blankline_trail = false,
        },
        scope = {
          -- char = '┃',
          char = '│',
          show_exact_scope = true,
          enabled = true,
          show_start = true,
          show_end = true,
          injected_languages = true,
          priority = 500,
        },
        exclude = {
          filetypes = {
            'help',
            'alpha',
            'markdown',
            'neo-tree',
            'lazy',
            'mason',
            'notify',
          },
        },
      }
    end,
    main = 'ibl',
  },
}
