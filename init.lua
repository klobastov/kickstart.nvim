vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Autocmd ]]
require 'autocmd'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
