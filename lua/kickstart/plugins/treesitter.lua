return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      ensure_installed = {
        'bash',
        'diff',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'php',
        'query',
        'regex',
        'sql',
        'tmux',
        'vim',
        'vimdoc',
      },
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = { 'markdown' },
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      -- require('nvim-dap-repl-highlights').setup()
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
