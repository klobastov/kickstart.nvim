local function short_session_name()
  local full_name = require('auto-session.lib').current_session_name(true)
  if not full_name or full_name == '' then
    return ''
  end

  -- Оставляем только имя файла без пути
  local name = full_name:match '([^/\\]+)$' or full_name

  -- Укорачиваем слишком длинные имена
  if #name > 20 then
    return name:sub(1, 20)
  end

  return name
end
return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'yavorski/lualine-macro-recording.nvim' },
    },
    opts = function()
      -- Простая функция определения темы
      local function get_theme()
        local handle = io.popen "readlink -f ~/.config/i3/colors-current 2>/dev/null | grep -o 'solarized-[a-z]*'"
        if handle then
          local theme = handle:read '*l'
          handle:close()
          if theme == 'solarized-light' then
            return 'solarized_light'
          end
          if theme == 'solarized-dark' then
            return 'solarized_dark'
          end
        end
        return 'solarized_light' -- по умолчанию
      end

      return {
        icons_enabled = vim.g.have_nerd_font,
        theme = get_theme(),
        disabled_filetypes = {
          statusline = { 'neo-tree' },
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
          lualine_c = {
            short_session_name,
            'macro_recording',
            '%S',
          },
          lualine_x = {
            '%S',
            'filetype',
          },
          lualine_y = {
            'progress',
          },
          lualine_z = { 'location' },
        },
      }
    end,
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
      vim.g.tpipeline_statusline = ''
      vim.o.laststatus = 0
      vim.defer_fn(function()
        vim.o.laststatus = 0
      end, 0)
      vim.o.fillchars = 'stl:─,stlnc:─,vert:│'
      vim.api.nvim_create_autocmd('OptionSet', {
        pattern = 'laststatus',
        callback = function()
          if vim.o.laststatus ~= 0 then
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
