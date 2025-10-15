return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true }, function(err)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), 'v') then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
              end
            end
          end)
        end,
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      -- Set default options
      default_format_opts = {
        lsp_format = 'fallback',
      },
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters = {
        -- sqlfluff = function()
        --   local util = require 'conform.util'
        --
        --   return {
        --     command = "sqlfluff",
        --     args = { "fix", "--dialect=postgres", "-" },
        --     stdin = true,
        --     -- exit_codes = { 0, 1 }, -- it seems to report any misformatted SQL as exit code 1
        --     cwd = util.root_file({ ".sqlfluff" }),
        --     require_cwd = false,
        --   }
        -- end,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'php_cs_fixer' },
        sql = { 'sql_formatter' }, -- 'sqlfmt' ugly, 'sqlfluff' cant format with parsing errros
        markdown = { 'markdownlint' },
        graphql = { 'prettierd' },
        html = { 'prettierd' },
        less = { 'prettierd' },
        scss = { 'prettierd' },
        css = { 'prettierd' },
        xml = { 'prettierd' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
    config = function(_, opts)
      require('conform.formatters.php_cs_fixer').args = function(_, ctx)
        local args = { 'fix', '$FILENAME', '--quiet', '--no-interaction', '--using-cache=yes' }
        local found = vim.fs.find('.php-cs-fixer.dist.php', { upward = true, path = ctx.dirname })[1]

        if found then
          vim.list_extend(args, { '--config=' .. found })
          return args
        else
          print 'add .php-cs-fixer.dist.php'
          return {}
        end
      end

      require('conform.formatters.sql_formatter').args = function(_, ctx)
        -- Example '--language', 'postgresql'
        local config_path = ctx.dirname .. '/.sql-formatter.json'
        if vim.uv.fs_stat(config_path) then
          return { '--config', config_path }
        else
          print 'add .sql-formatter.json'
          return {}
        end
      end

      require('conform.formatters.prettierd').args = function(_, ctx)
        local prettier_roots = { '.prettierrc', '.prettierrc.json', 'prettier.config.js' }
        local args = { '--stdin-filepath', '$FILENAME' }

        local found = vim.fs.find(prettier_roots, {
          upward = true,
          path = ctx.dirname,
          type = 'file',
        })[1]

        -- Project config takes precedence over global config
        if found then
          vim.list_extend(args, { '--config' .. found })
          return args
        else
          print 'add .prettierrc'
          return {}
        end
      end

      require('conform').setup(opts)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
