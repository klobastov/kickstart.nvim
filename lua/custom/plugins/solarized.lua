return {
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  ---@type solarized.config
  opts = {
    plugins = {
      navic = false,
      nvimtree = false,
      dashboard = false,
      noice = false,
      ministatusline = false,
      minitabline = false,
      ministarter = false,
      rainbowdelimiters = false,
    },
    transparent = {
      enabled = true, -- Master switch to enable transparency
      pmenu = true, -- Popup menu (e.g., autocomplete suggestions)
      normal = false, -- Main editor window background
      normalfloat = true, -- Floating windows
      lazy = true, -- Lazy plugin manager UI
      mason = true, -- Mason manage external tooling
      neotree = true, -- Neo-tree file explorer
      nvimtree = false, -- Nvim-tree file explorer
      telescope = true, -- Telescope fuzzy finder
      whichkey = true, -- Which-key popup
    },
  },
  config = function(_, opts)
    --vim.o.termguicolors = true
    vim.o.background = 'light'
    require('solarized').setup(opts)
    vim.cmd.colorscheme 'solarized'
  end,
}
