-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Diagnostic p[o]pup' })
vim.keymap.set('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Prev [d]iagnostic row' })
vim.keymap.set('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Next [d]iagnostic row' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Buffers navigation
vim.keymap.set('n', '<C-q>', '<cmd>bp<bar>bd#<cr>', { noremap = true, silent = true })

-- Tabs navigation
vim.keymap.set('n', 'H', '<cmd>tabprevious<CR>', { desc = 'Swith previous tab' })
vim.keymap.set('n', 'L', '<cmd>tabnext<CR>', { desc = 'Switch next tab' })
vim.keymap.set('n', 'Q', '<cmd>tabc<CR>', { desc = 'Close tab' })
vim.keymap.set('n', 'T', '<cmd>tabnew<CR>', { desc = 'Crate tab' })

-- @todo add Ctrl-F4 bind
-- vim.keymap.set('n', '<Leader>1', '<cmd>BufferLineGoToBuffer 1<CR>', { desc = 'Open buffer 1' })
-- vim.keymap.set('n', '<Leader>2', '<cmd>BufferLineGoToBuffer 2<CR>', { desc = 'Open buffer 2' })
-- vim.keymap.set('n', '<Leader>3', '<cmd>BufferLineGoToBuffer 3<CR>', { desc = 'Open buffer 3' })
-- vim.keymap.set('n', '<Leader>4', '<cmd>BufferLineGoToBuffer 4<CR>', { desc = 'Open buffer 4' })
-- vim.keymap.set('n', '<Leader>5', '<cmd>BufferLineGoToBuffer 5<CR>', { desc = 'Open buffer 5' })
-- vim.keymap.set('n', '<Leader>6', '<cmd>BufferLineGoToBuffer 6<CR>', { desc = 'Open buffer 6' })
-- vim.keymap.set('n', '<Leader>7', '<cmd>BufferLineGoToBuffer 7<CR>', { desc = 'Open buffer 7' })
-- vim.keymap.set('n', '<Leader>8', '<cmd>BufferLineGoToBuffer 8<CR>', { desc = 'Open buffer 8' })
-- vim.keymap.set('n', '<Leader>9', '<cmd>BufferLineGoToBuffer 9<CR>', { desc = 'Open buffer 9' })

-- Try disable close window for prevent exit vim
vim.keymap.set('n', '<C-w>q', '<nop>')
vim.keymap.set('n', '<C-w><C-q>', '<nop>')
-- Try fix C-Space as WORD [w] motion
vim.keymap.set('n', '<C-Space>', '<nop>')
vim.keymap.set('n', '<C-S-Space>', '<nop>')
vim.keymap.set('n', '<C-CR>', '<nop>')
vim.keymap.set('n', '<C-S-CR>', '<nop>')
-- Try fix Enter as line down [j] motion
vim.keymap.set('n', '<CR>', '<nop>')
-- Try fix Backspace as symbol left [h] motion
vim.keymap.set('n', '<BS>', '<nop>')

-- Try fix TABs add on insert mode
vim.keymap.set('i', '<TAB>', '<nop>')
vim.keymap.set('i', '<S-TAB>', '<nop>')

-- Save buffer
vim.keymap.set('n', '<C-s>', '<cmd>update<CR>', { desc = 'Save buffer' })
vim.keymap.set('i', '<C-s>', '<ESC><cmd>update<CR>gi', { desc = 'Save buffer' })
vim.keymap.set('v', '<C-s>', '<C-C><cmd>:update<CR>', { desc = 'Save buffer' })

-- vim: ts=2 sts=2 sw=2 et
