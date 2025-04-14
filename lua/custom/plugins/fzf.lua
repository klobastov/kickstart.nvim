return {
  'junegunn/fzf',
  event = 'Bufenter',
  run = function()
    vim.fn['fzf#install']()
  end,
  keys = {
    {
      '<leader><leader>',
      '<cmd>FZF<cr>',
      mode = 'n',
      desc = 'Fuzzy Finder',
    },
  },
}
