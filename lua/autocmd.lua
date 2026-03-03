local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

local lsp = require 'utils.lsp'
local loclist = require 'utils.loclist'
local user_grp = augroup('UserGroup', { clear = true })

--autocmd('FileType', {
--  desc = 'Commenting .sql',
--  command = "setlocal commentstring=--%s",
--  group = user_grp,
--})
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
--   desc = 'Hide foldcolumn for some file types',
--   pattern = { 'neo-tree' }, -- Apply to buffers with the "neo-tree" filetype
--   group = user_grp,
--   callback = function()
--     vim.opt_local.foldcolumn = '0'
--     vim.opt_local.foldenable = false
--     vim.opt_local.spell = false
--     vim.opt_local.signcolumn = 'no'
--   end,
-- })
autocmd({ 'BufNewFile', 'BufRead' }, {
  desc = 'Highlight avro as json',
  pattern = '*.avsc',
  command = 'setfiletype json',
})

usercmd('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  bang = true,
  desc = 'Disable autoformat-on-save',
})

usercmd('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

-- autocmd('FileType', {
--   desc = 'Disable columns in neo-tree',
--   pattern = { 'neo-tree' },
--   callback = function()
--     vim.opt_local.foldenable = false
--     vim.opt_local.foldcolumn = '0'
--     vim.opt_local.signcolumn = 'no'
--     vim.opt_local.colorcolumn = ''
--     vim.opt_local.wrap = false
--     vim.opt_local.spell = false
--   end,
--   group = user_grp,
-- })

autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 100,
    }
  end,
  group = user_grp,
})

autocmd('BufWritePre', {
  desc = 'Remove trailing whitespace on save',
  callback = function()
    -- Save cursor position to later restore
    local curpos = vim.api.nvim_win_get_cursor(0)
    -- Search and replace trailing whitespace
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.api.nvim_win_set_cursor(0, curpos)
  end,
  group = user_grp,
})

autocmd('BufWinEnter', {
  desc = 'Open help window in a vertical split if it fits better',
  pattern = {
    vim.fn.expand '$VIMRUNTIME' .. '/doc/*.txt',
    vim.fn.stdpath 'state' .. '/lazy/readme/doc/*.{txt,md}',
    vim.fn.stdpath 'data' .. '/lazy/*/doc/*.{txt,md}',
  },
  callback = function(ev)
    if not vim.bo[ev.buf].buftype == 'help' then
      return
    end
    -- First move to the very bottom
    vim.cmd.wincmd 'J'
    local win_width = vim.api.nvim_win_get_width(0)
    local help_min_width = 78
    local more_than_double = win_width > 2 * help_min_width
    if more_than_double then
      -- Move the the very right
      vim.cmd.wincmd 'L'
    end
  end,
  group = user_grp,
})

autocmd({ 'BufWritePre' }, {
  desc = 'Auto create dir when saving a file, in case some intermediate directory does not exist',
  group = user_grp,
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Diagnostics to location list
-- lsp.on_attach(function(client, buffer)
--   -- BUG the first list is not being popullated
--   autocmd({ 'DiagnosticChanged', 'WinEnter', 'BufEnter' }, {
--     -- buffer = buffer,
--     desc = 'Put diagnostics on location list',
--     callback = function(event)
--       local lsp_clients = vim.lsp.get_clients { bufnr = event.buf }
--       if #lsp_clients == 0 then
--         return
--       end
--
--       local is_normal_mode = vim.fn.mode() == 'n'
--       if not is_normal_mode then
--         return
--       end
--
--       -- vim.notify("Setting loclist from diagnostic.", vim.log.levels.INFO)
--       local opened = loclist.is_visible()
--       vim.diagnostic.setloclist { open = opened }
--     end,
--     group = augroup('DiagnosticLocList', { clear = true }),
--   })
-- end, { desc = 'LSP diagnostic to location list' })

-- autocmd('QuitPre', {
--   callback = function()
--     vim.cmd.cclose()
--     vim.cmd.lclose()
--     -- check if command exists
--     if vim.fn.exists ':Neotree' == 2 then
--       vim.cmd { cmd = 'Neotree', args = { 'close' } }
--     end
--   end,
--   group = user_grp,
-- })
