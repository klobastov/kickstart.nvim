-- Глобальная таблица для отслеживания реально открытых буферов
if not _G.user_opened_buffers then
  _G.user_opened_buffers = {}

  -- Автокоманда для отслеживания когда файл открывается в обычном окне (не preview)
  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(args)
      local buf = args.buf
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == '' and vim.api.nvim_buf_get_name(buf) ~= '' then
        -- Проверяем что это не preview окно
        local current_win = vim.api.nvim_get_current_win()
        if not vim.api.nvim_win_get_option(current_win, 'previewwindow') then
          _G.user_opened_buffers[buf] = true
        end
      end
    end,
  })

  -- Очищаем буферы при их закрытии
  vim.api.nvim_create_autocmd('BufWipeout', {
    callback = function(args)
      _G.user_opened_buffers[args.buf] = nil
    end,
  })
end
local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require 'telescope.actions'
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require 'telescope.actions.state'
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require('neo-tree.sources.filesystem').navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  lazy = false,
  tag = '3.28',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', '<cmd>Neotree toggle<CR>', desc = 'NeoTree' },
    { '<C-\\>', '<cmd>Neotree reveal<CR>', desc = 'NeoTree reveal' },
  },
  opts = {
    auto_clean_after_session_restore = true,
    enable_diagnostics = true,
    enable_git_status = true,
    git_status_async = true,
    use_default_mappings = true,
    enable_modified_markers = false,
    enable_refresh_on_write = true,
    log_to_file = false,
    resize_timer_interval = -1,
    use_popups_for_input = false,
    sources = { 'filesystem', 'git_status', 'buffers' },
    default_component_configs = {
      diagnostics = {
        symbols = {
          error = '', -- Иконка для ошибок
          warn = '', -- Иконка для предупреждений
          info = '', -- Иконка для информации
          hint = '', -- Иконка для подсказок
        },
        highlights = {
          hint = 'DiagnosticSignHint',
          info = 'DiagnosticSignInfo',
          warn = 'DiagnosticSignWarn',
          error = 'DiagnosticSignError',
        },
      },
    },
    window = {
      width = 60,
      auto_expand_width = true,
      mappings = {
        ['<space>'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
        -- ['P'] = 'noop',
        ['/'] = 'noop',
        ['q'] = 'noop',
        ['<cr>'] = function(state)
          state.commands['open'](state)
          vim.cmd 'Neotree reveal'
        end,
        ['<tab>'] = function() end,
        ['@'] = 'telescope_find',
        ['$'] = 'telescope_grep',
        -- Копировать путь файла в буфер обмена
        ['Y'] = {
          function(state)
            local node = state.tree:get_node()
            if node and node.type == 'file' then
              local filepath = node:get_id()
              -- Копируем путь в оба буфера
              vim.fn.system('tmux set-buffer "' .. vim.fn.shellescape(filepath) .. '"')
              local tmp_file = '/tmp/nvim_shared_file'
              vim.fn.writefile({ filepath }, tmp_file)
              vim.notify('📋 Path copied: ' .. filepath)
            else
              vim.notify('❌ Please select a file', vim.log.levels.WARN)
            end
          end,
          desc = 'Copy file path to shared buffer',
        },
        ['P'] = {
          function(state)
            local sources = {}

            -- Проверяем tmux буфер
            local tmux_content = vim.fn.system('tmux show-buffer -s0 2>/dev/null'):gsub('\n', '')
            if vim.v.shell_error == 0 and tmux_content ~= '' then
              table.insert(sources, { 'tmux', tmux_content })
            end

            -- Проверяем tmp файл
            local tmp_file = '/tmp/nvim_shared_file'
            if vim.fn.filereadable(tmp_file) == 1 then
              local tmp_content = vim.fn.readfile(tmp_file)[1]
              table.insert(sources, { 'tmp', tmp_content })
            end

            if #sources == 0 then
              vim.notify('❌ No shared files found', vim.log.levels.WARN)
              return
            end

            local source_filepath = sources[1][2]

            if vim.fn.filereadable(source_filepath) == 1 then
              -- Получаем имя файла по умолчанию
              local default_filename = vim.fn.fnamemodify(source_filepath, ':t')

              -- Определяем целевую директорию на основе текущего узла в neo-tree
              local target_dir
              local node = state.tree:get_node()

              if node then
                if node.type == 'directory' then
                  -- Если выбран каталог - используем его
                  target_dir = node:get_id()
                else
                  -- Если выбран файл - используем родительский каталог
                  target_dir = vim.fn.fnamemodify(node:get_id(), ':h')
                end
              else
                -- Если нет выбранного узла - используем корневую директорию neo-tree
                target_dir = state.path
              end

              -- Спрашиваем новое имя файла
              local new_filename = vim.fn.input('New filename [' .. default_filename .. ']: ', default_filename)
              if new_filename == '' then
                new_filename = default_filename
              end

              -- Создаем полный путь для нового файла
              local target_filepath = target_dir .. '/' .. new_filename

              -- Копируем файл
              local success = os.execute('cp "' .. source_filepath .. '" "' .. target_filepath .. '"')

              if success then
                vim.notify('📁 File copied to: ' .. target_filepath)
              else
                vim.notify('❌ Copy failed', vim.log.levels.ERROR)
              end
            else
              vim.notify('❌ Source file not found: ' .. source_filepath, vim.log.levels.ERROR)
            end
          end,
          desc = 'Paste file with new name',
        },
      },
    },
    buffers = {
      -- bind_to_cwd = false, -- Для подсветки открытых буфферов
      follow_current_file = {
        enabled = false,
        leave_dirs_open = true,
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = false, -- Автоматически обновляет дерево при смене файла
      },
      hijack_netrw_behavior = 'open_current',
      use_libuv_file_watcher = true,
      find_by_full_path_words = true,
      -- bind_to_cwd = true,
      bind_to_cwd = false,
      find_command = 'fd',
      find_args = {
        fd = {
          '--exclude',
          '.git',
          '--exclude',
          'node_modules',
          '--exclude',
          'vendor',
        },
      },
      window = {
        mappings = {
          ['/'] = 'noop',
        },
      },
      commands = {
        telescope_find = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').find_files(getTelescopeOpts(state, path))
        end,
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
        end,
      },
      components = {
        buffer_number = function(config, node, _)
          local path = node:get_id()
          if not path or path == '' then
            return {}
          end

          local normalized_path = vim.fn.fnamemodify(path, ':p')

          -- Ищем буфер с этим путем в списке пользовательских буферов
          for buf, _ in pairs(_G.user_opened_buffers) do
            if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
              local buf_path = vim.api.nvim_buf_get_name(buf)
              local normalized_buf_path = vim.fn.fnamemodify(buf_path, ':p')

              if normalized_path == normalized_buf_path then
                return {
                  text = string.format(' #%d', buf),
                  highlight = config.highlight or 'NeoTreeDirectoryIcon',
                }
              end
            end
          end

          return {}
        end,
        -- harpoon_index = function(config, node, _)
        --   local harpoon_list = require('harpoon'):list()
        --   local path = node:get_id()
        --   local harpoon_key = vim.uv.cwd()
        --
        --   for i, item in ipairs(harpoon_list.items) do
        --     local value = item.value
        --     if string.sub(item.value, 1, 1) ~= '/' then
        --       value = harpoon_key .. '/' .. item.value
        --     end
        --
        --     if value == path then
        --       vim.print(path)
        --       return {
        --         text = string.format(' ⥤ %d', i), -- <-- Add your favorite harpoon like arrow here
        --         highlight = config.highlight or 'NeoTreeDirectoryIcon',
        --       }
        --     end
        --   end
        --   return {}
        -- end,
      },
      renderers = {
        file = {
          { 'icon' },
          { 'name', use_git_status_colors = true, zindex = 10 },
          { 'bufnr', zindex = 10 },
          { 'buffer_number' },
          { 'diagnostics', zindex = 20, align = 'right' },
        },
        directory = {
          { 'icon' },
          { 'name', use_git_status_colors = true, zindex = 10 },
        },
      },
      find_by_name = {
        hide_openned_buffers = true,
      },
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        -- hide_by_name = {
        --   '.git',
        --   'vendor',
        --   'node_modules',
        -- },
        never_show = {},
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
  end,
}
