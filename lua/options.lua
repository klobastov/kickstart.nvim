-----------------------------------------------------------
-- Core [Providers]
-----------------------------------------------------------
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-----------------------------------------------------------
-- General
-----------------------------------------------------------
vim.o.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this oion if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.swapfile = true -- Save buffer backups history
vim.o.undofile = true -- Save undo history

-----------------------------------------------------------
-- Look and Feel
-----------------------------------------------------------
vim.o.background = 'light'

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
vim.o.number = true -- Show line number
vim.o.showmatch = true -- Highlight matching parenthesis
vim.o.splitright = true -- Vertical split to the right
vim.o.splitbelow = true -- Horizontal split to the bottom
vim.o.ignorecase = true -- Ignore case letters when search
vim.o.smartcase = true -- Ignore lowercase for the whole pattern
vim.o.linebreak = true -- Wrap on word boundary
-- vim.o.breakindent = true
vim.o.termguicolors = true -- Enable 24-bit RGB colors
vim.o.laststatus = 3 -- Set global statusline
vim.o.cmdheight = 1 -- Hide cmd line
vim.o.ruler = false -- Show the line and column number of the cursor position, separated by comma
vim.o.conceallevel = 0 -- Show all symbols without conceal process

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
vim.o.hidden = true -- Enable background buffers
vim.o.history = 2000 -- Remember N lines in history
--vim.o.lazyredraw = true -- Faster scrolling
vim.o.synmaxcol = 240 -- Max column for syntax highlight
vim.o.updatetime = 250 -- ms to wait for trigger an event

-----------------------------------------------------------
-- Editor
-----------------------------------------------------------
vim.o.modeline = false
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.startofline = false -- Additional no next option
vim.o.virtualedit = 'all' -- Save cursor position on movement
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.o.relativenumber = true -- You can also add relative line numbers, to help with jumping.
vim.o.showmode = false -- Don't show the mode, since it's already in the status line
vim.o.signcolumn = 'yes:1' -- Keep signcolumn on by default
vim.opt.list = true -- Sets how neovim will display certain whitespace characters in the editor.opt
-- Show those damn hidden characters
vim.opt.listchars = 'tab: >,nbsp:¬,extends:»,precedes:«,trail:•'
vim.o.cursorline = false -- Show which line your cursor is on
vim.o.scrolloff = 1 -- Minimal number of screen lines to keep above and below the cursor.
-- vim.o.scrollback = 3
vim.o.inccommand = 'split' -- Preview substitutions live, as you type!
-- vim.o.showcmdloc = 'statusline' -- Status line of the current window

-- Use wide tabs
vim.o.smartindent = false
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.indentexpr = 'v:lua.vim.nvim_treesitter.indent()'

-- Wrapping options
vim.o.colorcolumn = '121' -- Line length marker at 120 columns
vim.o.wrap = true
vim.o.textwidth = 120
vim.o.wrapmargin = 0
vim.o.formatoptions = 'tc' -- wrap text and comments using textwidth
vim.o.formatoptions = vim.o.formatoptions .. 'r' -- continue comments when pressing ENTER in I mode
vim.o.formatoptions = vim.o.formatoptions .. 'q' -- enable formatting of comments with gq
vim.o.formatoptions = vim.o.formatoptions .. 'n' -- detect lists for formatting
vim.o.formatoptions = vim.o.formatoptions .. 'b' -- auto-wrap in insert mode, and do not wrap old long lines

-- Backspace over newline
vim.o.backspace = 'indent,eol,start'
vim.diagnostic.config {
  float = {
    source = true,
  },
  signs = true,
  severity_sort = true,
}

--spell
vim.opt.spelllang = { 'en_us', 'ru' }
vim.opt.spelloptions = { 'camel' }
vim.o.spellsuggest = 'fast'
vim.opt.spellfile = {
  vim.fn.stdpath 'config' .. '/spell/en.utf-8.add',
}
vim.o.spellcapcheck = '' -- don't check for capital letters at start of sentence
vim.o.fileformats = 'unix,mac,dos'
vim.o.spell = true

-- folding
vim.o.foldenable = false -- Enable folding.
vim.o.foldcolumn = '4' -- Show folding signs.
-- Folds with a level > foldlevel will be closed
-- Setting 0 will close all folds
-- Setting 99 ensures folds are open by default
vim.o.foldlevel = 0
-- Fold all, which have nesting above 3
vim.o.foldlevelstart = 3
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = ''
vim.o.foldnestmax = 5
vim.o.foldminlines = 10
vim.o.foldopen = 'insert,search,block,jump,quickfix' -- Which commands open folds if the cursor moves into a closed fold.
vim.o.foldclose = 'all' -- Which commands open folds if the cursor moves into a closed fold.
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.o.emoji = false
-----------------------------------------------------------
-- Plugins [Auto-sessions]
-----------------------------------------------------------
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- vim: ts=2 sts=2 sw=2 et
