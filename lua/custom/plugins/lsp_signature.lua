return {
  'ray-x/lsp_signature.nvim',
  event = 'InsertEnter',
  enabled = true,
  opts = {
    bind = true,
    hint_enable = false,
    handler_opts = {
      border = 'single',
    },
  },
  keys = {
    {
      '<C-l>',
      function()
        require('lsp_signature').toggle_float_win()
      end,
      mode = 'i',
      desc = 'Lsp Signature',
    },
  },
  config = function(_, opts)
    require('lsp_signature').setup(opts)
  end,
}
