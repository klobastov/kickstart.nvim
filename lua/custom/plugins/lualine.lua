return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      icons_enabled = vim.g.have_nerd_font,
      theme = 'solarized_light',
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      refresh = {
        statusline = 1000,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {},
        lualine_x = {
          'encoding',
          {
            'tabs',
            tab_max_length = 40,
            max_length = vim.o.columns / 4,
            mode = 1,
            show_modified_status = false,
            section_separators = {
              left = '',
              right = '',
            },
            padding = 1,
          },
          '%S', -- showcmd, requires showcmdloc=statusline
          'filetype',
        },
        lualine_y = {
          'progress',
        },
        lualine_z = { 'location' },
      },
    },
    config = function(_, opts)
      require('lualine').setup(opts)

      --- Workaround to make lualine work with tpipeline
      if vim.env.TMUX ~= nil then
        local lualine_nvim_opts = require 'lualine.utils.nvim_opts'
        local base_set = lualine_nvim_opts.set

        local tpipeline_update = function()
          vim.cmd 'silent! call tpipeline#update()'
        end

        ---@diagnostic disable-next-line: duplicate-set-field
        lualine_nvim_opts.set = function(name, val, scope)
          if name == 'statusline' then
            if scope and scope.window == vim.api.nvim_get_current_win() then
              vim.g.tpipeline_statusline = val
              tpipeline_update()
            end
            return
          end
          return base_set(name, val, scope)
        end
      end
    end,
  },
  {
    'vimpostor/vim-tpipeline',
    event = 'VeryLazy',
    init = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_statusline = ''
    end,
    config = function()
      vim.cmd.hi { 'link', 'StatusLine', 'WinSeparator' }
      vim.g.tpipeline_statusline = ''
      vim.o.laststatus = 0
      vim.defer_fn(function()
        vim.o.laststatus = 0
      end, 0)
      vim.o.fillchars = 'stl:─,stlnc:─'
      vim.api.nvim_create_autocmd('OptionSet', {
        pattern = 'laststatus',
        callback = function()
          if vim.o.laststatus ~= 0 then
            vim.notify 'Auto-setting laststatus to 0'
            vim.o.laststatus = 0
          end
        end,
      })
    end,
    cond = function()
      return vim.env.TMUX ~= nil
    end,
    dependencies = {
      'nvim-lualine/lualine.nvim',
    },
  },
}
