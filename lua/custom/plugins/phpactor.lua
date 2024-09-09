return {
  {
    'gbprod/phpactor.nvim',
    build = function()
      require 'phpactor.handler.update'()
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      install = {
        path = vim.fn.stdpath 'data' .. '/mason/packages/phpactor/',
        bin = vim.fn.stdpath 'data' .. '/mason/packages/phpactor/phpactor.phar',
      },
      lspconfig = {
        enabled = false,
      },
    },
  },
}
