return {
  {
    'gbprod/phpactor.nvim',
    enabled = true,
    build = function()
      require 'phpactor.handler.update'()
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    ft = 'php',
    keys = {
      { '<Leader>ll', '<cmd>PhpActor context_menu<CR>', buffer = true, noremap = true, silent = true, desc = 'PhpActor: context [A]ctions', ft = { 'php' } },
    },
    cmd = { 'PhpActor' },
    opts = {
      install = {
        path = '/opt/phpactor/',
        branch = 'master',
        bin = '/opt/phpactor/bin/phpactor',
        php_bin = 'php',
        composer_bin = 'composer',
        git_bin = 'git',
        check_on_startup = 'none',
      },
      lspconfig = {
        enabled = true,
      },
    },
  },
}
