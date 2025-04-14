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
        options = {
          -- ['completion.label_formatter'] = 'helpful',
          -- ['completion_worse.completor.attribute.enabled'] = true,
          -- ['completion_worse.completor.class_like.enabled'] = true,
          -- ['completion_worse.completor.constant.enabled'] = true,
          -- ['completion_worse.completor.declared_class.enabled'] = true,
          -- ['completion_worse.completor.declared_constant.enabled'] = true,
          -- ['completion_worse.completor.declared_function.enabled'] = true,
          -- ['completion_worse.completor.docblock.enabled'] = true,
          -- ['completion_worse.completor.doctrine_annotation.enabled'] = true,
          -- ['completion_worse.completor.expression_name_search.enabled'] = true,
          -- ['completion_worse.completor.imported_names.enabled'] = true,
          -- ['completion_worse.completor.named_parameter.enabled'] = true,
          -- ['completion_worse.completor.scf_class.enabled'] = true,
          -- ['completion_worse.completor.subscript.enabled'] = true,
          -- ['completion_worse.completor.symfony.enabled'] = true,
          -- ['completion_worse.completor.type.enabled'] = true,
          -- ['completion_worse.completor.use.enabled'] = true,
          -- ['completion_worse.snippets'] = true,
        },
      },
    },
  },
}
