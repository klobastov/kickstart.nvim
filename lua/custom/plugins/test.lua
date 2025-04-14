return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux',
  },
  keys = {
    { '<leader>ct', '<cmd>TestNearest<cr>', mode = 'n', desc = '[T]est nearest' },
    { '<leader>cf', '<cmd>TestFile<cr>', mode = 'n', desc = 'Test [f]ile' },
    { '<leader>cs', '<cmd>TestSuite<cr>', mode = 'n', desc = 'Test [s]uite' },
    { '<leader>cl', '<cmd>TestLast<cr>', mode = 'n', desc = 'Test [l]ast' },
    { '<leader>cv', '<cmd>TestVisit<cr>', mode = 'n', desc = 'Test [v]isit' },
  },
  config = function()
    vim.cmd 'let test#strategy = "vimux"'
  end,
}
