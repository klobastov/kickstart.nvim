return {
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  ---@type solarized.config
  opts = {
    variant = 'winter', -- "spring" | "summer" | "autumn" | "winter" (default)
    error_lens = {
      text = false,
      symbol = false,
    },
    plugins = {
      treesitter = true,
      lspconfig = true,
      navic = false,
      cmp = true,
      indentblankline = true,
      neotree = true,
      nvimtree = false,
      whichkey = true,
      dashboard = false,
      gitsigns = true,
      telescope = true,
      noice = false,
      hop = false,
      ministatusline = false,
      minitabline = false,
      ministarter = false,
      minicursorword = false,
      notify = false,
      rainbowdelimiters = false,
      bufferline = false,
      lazy = true,
      rendermarkdown = false,
      ale = false,
      coc = false,
      leap = false,
      alpha = false,
      yanky = false,
      gitgutter = false,
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
    on_highlights = function(colors, color)
      ---@type solarized.highlights
      return {
        CybuFocus = { bg = colors.blue, fg = colors.base2 },
        Constant = { bg = colors.base2 },
        Keyword = { bold = false, fg = colors.base02 }, -- like variables
        Identifier = { fg = colors.base01 },
        Function = {
          -- bg = colors.base2
          bold = true,
        },
        TelescopeBorder = { fg = colors.cyan },
        TelescopePromptBorder = { fg = colors.blue },
        Visual = { bg = colors.blue, fg = colors.base2 },
        ['@punctuation.bracket'] = { fg = colors.yellow },
      }
    end,
  },
  config = function(_, opts)
    require('solarized').setup(opts)
    vim.opt.background = 'light'
    vim.cmd.colorscheme 'solarized'
  end,
}
