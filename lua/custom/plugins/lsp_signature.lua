return {
  'ray-x/lsp_signature.nvim',
  event = 'InsertEnter',
  enabled = false,
  opts = {
    bind = true,
    handler_opts = {
      border = 'single',
    },
  },
  config = function(_, opts)
    require('lsp_signature').setup(opts)
  end,
}
