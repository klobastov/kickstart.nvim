---@diagnostic disable: missing-fields
return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePost' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        php = { 'phpstan', 'deptrac' }, -- see below - moved phpstan to ALE for now to avoid blocking the UI on save
        --sql = { 'sqlfluff' }
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Функция для поиска корня проекта с абсолютным путем
      local function find_project_root()
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir = vim.fn.fnamemodify(current_file, ':p:h')

        local config_files = { 'deptrac.yaml', 'deptrac.yml', 'composer.json' }
        for _, config_file in ipairs(config_files) do
          local found = vim.fn.findfile(config_file, current_dir .. ';')
          if found ~= '' then
            return vim.fn.fnamemodify(found, ':p:h')
          end
        end

        return current_dir
      end

      local project_root = find_project_root()
      -- Основной Deptrac линтер
      lint.linters.deptrac = {
        cmd = 'sh',
        args = { '-c', 'cd "' .. project_root .. '" && deptrac analyze --formatter=json --no-progress --fail-on-uncovered --report-uncovered' },
        stream = 'stdout',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          if output:match 'Config file cannot be found' then
            return {}
          end

          local success, data = pcall(vim.json.decode, output)
          if not success then
            return {}
          end

          local diagnostics = {}
          local current_file = vim.api.nvim_buf_get_name(bufnr)
          local current_filename = vim.fn.fnamemodify(current_file, ':t')

          -- Функция для определения severity на основе типа сообщения
          local function get_severity(message_type)
            if message_type == 'error' then
              return vim.diagnostic.severity.WARN
            elseif message_type == 'warning' then
              return vim.diagnostic.severity.HINT
            else
              return vim.diagnostic.severity.INFO
            end
          end

          if data.files then
            for file_path, file_data in pairs(data.files) do
              local report_filename = vim.fn.fnamemodify(file_path, ':t')
              if file_data.messages and current_filename == report_filename then
                for _, message in ipairs(file_data.messages) do
                  -- Определяем тип сообщения на основе содержимого
                  local message_type = 'error' -- по умолчанию
                  local message_text = message.message

                  -- Анализируем сообщение для определения типа
                  if message_text:lower():match 'warning' then
                    message_type = 'warning'
                  elseif message_text:lower():match 'info' or message_text:lower():match 'hint' then
                    message_type = 'info'
                  end

                  -- Если в сообщении есть явное указание типа
                  if message.type then
                    message_type = message.type
                  end
                  table.insert(diagnostics, {
                    lnum = (message.line or 1) - 1,
                    col = message.column and (message.column - 1) or 0,
                    message = message_text,
                    severity = get_severity(message_type),
                    source = 'deptrac',
                  })
                end
              end
            end
          end

          return diagnostics
        end,
      }
      table.insert(lint.linters.phpstan.args, '--memory-limit=256M')

      -- local diagnostic_opts = {
      --   underline = true,
      --   update_in_insert = false,
      --   virtual_text = false,
      --   -- virtual_text = {
      --   --   prefix = '●',
      --   --   spacing = 4,
      --   -- },
      --   severity_sort = true,
      --   signs = {
      --     text = {
      --       [vim.diagnostic.severity.ERROR] = '',
      --       [vim.diagnostic.severity.WARN] = '',
      --       [vim.diagnostic.severity.HINT] = '',
      --       [vim.diagnostic.severity.INFO] = '',
      --     },
      --   },
      -- }
      --
      -- local md = require('lint').get_namespace 'markdownlint'
      -- vim.diagnostic.config(diagnostic_opts, md)
      --
      -- local php = require('lint').get_namespace 'phpstan'
      -- vim.diagnostic.config(diagnostic_opts, php)
      --
      -- local deptrac = require('lint').get_namespace 'deptrac'
      -- vim.diagnostic.config(diagnostic_opts, deptrac)

      --local sql = require('lint').get_namespace 'sqlfluff'
      --vim.diagnostic.config(diagnostic_opts, sdl)

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
