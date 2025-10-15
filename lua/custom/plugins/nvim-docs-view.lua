return {
  'amrbashir/nvim-docs-view',
  lazy = true,
  enabled = false,
  cmd = 'DocsViewUpdate',
  opts = {
    position = 'right',
    width = 120,
    update_mode = 'manual',
  },
  keys = {
    {
      '<leader>td',
      '<cmd>DocsViewUpdate<CR>',
      mode = 'n',
      desc = '[D]ocs View Toggle',
    },
  },
}
