return {
  'maxmx03/solarized.nvim',
  event = 'VeryLazy',
  lazy = false,
  priority = 1000,
  ---@type solarized.config
  opts = {
    variant = 'autumn', -- "spring" | "summer" | "autumn" | "winter" (default)
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
      noice = true,
      hop = false,
      ministatusline = false,
      minitabline = false,
      ministarter = false,
      minicursorword = false,
      notify = false,
      rainbowdelimiters = false,
      bufferline = false,
      lazy = true,
      rendermarkdown = true,
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
      normal = true, -- Main editor window background
      normalfloat = true, -- Floating windows
      neotree = true, -- Neo-tree file explorer
      nvimtree = true, -- Nvim-tree file explorer
      whichkey = true, -- Which-key popup
      telescope = true, -- Telescope fuzzy finder
      lazy = true, -- Lazy plugin manager UI
      mason = true, -- Mason manage external tooling
    },
    on_highlights = function(hl, colors) -- 1. Правильный порядок аргументов
      -- Определяем, светлая ли тема, чтобы подбирать корректные цвета
      local is_light = vim.o.background == 'light'

      -- 2. Базовые цвета для условной логики
      local bg_color = is_light and colors.base3 or colors.base03
      local fg_color = is_light and colors.base00 or colors.base0
      local subtle_color = is_light and colors.base2 or colors.base02

      return {
        -- Ваши кастомные группы (ИСПРАВЛЕНО)
        Constant = { bg = subtle_color }, -- Используем conditional цвет
        Keyword = { bold = false, fg = is_light and colors.base02 or colors.base2 },
        Identifier = { fg = colors.base01 },
        Function = { bold = true },
        TelescopeBorder = { fg = colors.cyan },
        TelescopePromptBorder = { fg = colors.blue },
        Visual = { bg = colors.blue, fg = colors.base2 },
        ['@punctuation.bracket'] = { fg = colors.yellow },
        StatusLine = {
          fg = colors.base01, -- цвет комментариев
          bg = 'NONE', -- прозрачный фон
          underline = false,
          undercurl = false,
        },

        StatusLineNC = {
          fg = subtle, -- более subtle цвет
          bg = 'NONE', -- прозрачный фон
        },
        VertSplit = {
          fg = subtle,
          bg = 'NONE',
          bold = false,
        },
        WinSeparator = {
          fg = subtle,
          bg = 'NONE', -- Прозрачный фон
          bold = false,
        },
        -- Также добавьте, если используете вкладки
        TabLine = {
          fg = colors.base01,
          bg = 'NONE',
        },

        TabLineFill = {
          bg = 'NONE', -- фон заполнения вкладок
        },

        TabLineSel = {
          fg = colors.yellow, -- выделенная вкладка
          bg = 'NONE',
          bold = true,
        },
        -- Группы из предупреждения tpipeline (ДОБАВЛЕНО)
        FloatShadow = { blend = 20, bg = bg_color },
        FloatShadowThrough = { blend = 50, bg = bg_color },
        NvimInternalError = { fg = colors.base3, bg = colors.red, bold = true },
        NvimFigureBrace = { fg = colors.yellow, bold = true },
        NvimSingleQuotedUnknownEscape = { fg = colors.orange, italic = true },
        NvimInvalidSingleQuotedUnknownEscape = { fg = colors.red, bold = true, underline = true },
        RedrawDebugClear = { fg = fg_color, bg = colors.red, bold = true },
        RedrawDebugComposed = { fg = fg_color, bg = colors.green, bold = true },
        RedrawDebugRecompose = { fg = fg_color, bg = colors.blue, bold = true },
      }
    end,
  },
  config = function(_, opts)
    require('solarized').setup(opts)
    -- vim.opt.background = 'light'
    vim.cmd.colorscheme 'solarized'
  end,
}
