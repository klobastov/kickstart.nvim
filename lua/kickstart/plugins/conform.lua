return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
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
      formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'php_cs_fixer' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
    config = function(_, opts)
      require('conform.formatters.php_cs_fixer').args = function(_, ctx)
        local args = { 'fix', '$FILENAME', '--quiet', '--no-interaction', '--using-cache=no' }
        local found = vim.fs.find('.php-cs-fixer.php.dist', { upward = true, path = ctx.dirname })[1]
        if found then
          vim.list_extend(args, { '--config=' .. found })
        else
          vim.list_extend(args, { '--rules=@PSR12,@Symfony' })
        end

        return args
      end

      require('conform').setup(opts)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
