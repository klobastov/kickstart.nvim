local fn = vim.fn

function _G.qftf(info)
  local items
  local ret = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  -- It's a good opportunity to change current directory in quickfixtextfunc :)
  --
  -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
  --
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'

local function setup()
  local base03 = '#002b36'
  local base02 = '#073642'
  local base01 = '#586e75'
  local base00 = '#657b83'
  local base0 = '#839496'
  local base1 = '#93a1a1'
  local base2 = '#eee8d5'
  local base3 = '#fdf6e3'
  local yellow = '#b58900'
  local orange = '#cb4b16'
  local red = '#dc322f'
  local magenta = '#d33682'
  local violet = '#6c71c4'
  local blue = '#268bd2'
  local cyan = '#2aa198'
  local green = '#859900'

  require('bqf').setup {
    auto_enable = true,
    magic_window = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
      auto_preview = true,
      border = 'single',
      buf_label = true,
      delay_syntax = 80,
      show_scroll_bar = false,
      show_title = false,
      should_preview_cb = function(bufnr, _)
        local ret = true
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(bufname)
        if fsize > 100 * 1024 then
          ret = false
        elseif bufname:match '^fugitive://' then
          ret = false
        end
        return ret
      end,
      win_height = 12,
      win_vheight = 12,
      winblend = 0,
      wrap = false,
    },
    -- make `drop` and `tab drop` to become preferred
    func_map = {
      drop = 'o', -- use drop to open the item, and close quickfix window
      openc = 'O', -- open the item, and close quickfix window
      split = '<C-s>', -- default '<C-x>' -- open the item in horizontal split
      vsplit = '<C-v>', -- open the item in vertical split
      -- set to empty string to disable
      tabdrop = '', -- default '' -- use tab drop to open the item, and close quickfix window
      tab = '', -- default 't' -- open the item in a new tab
      tabb = '', -- default 'T' -- open the item in a new tab, but stay in quickfix window
      tabc = '', -- default '<C-t>' -- open the item in a new tab, and close quickfix window
      ptogglemode = 'qp', -- default 'zp' -- toggle preview window between normal and max size
      fzffilter = 'qz', -- default 'zf' -- enter fzf mode
      filter = 'qs', -- default 'zn' -- create new list for signed item
      filterr = 'qn', -- default 'zN' -- create new list for non-signed item
    },
    filter = {
      fzf = {
        action_for = {
          ['ctrl-q'] = 'signtoggle',
          ['ctrl-c'] = 'closeall',
        },
        --export FZF_DEFAULT_OPTS="
        --  --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
        --  --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
        --"
        extra_opts = {
          '--bind',
          'ctrl-o:toggle-all',
          '--delimiter',
          '│',
          '--color', -- https://github.com/junegunn/fzf/wiki/Color-schemes#alternate-solarized-lightdark-theme
          'fg:-1,bg:-1,hl:' .. blue .. ',fg+:' .. base02 .. ',bg+:' .. base2 .. ',hl+:' .. blue,
          '--color',
          'info:' .. yellow .. ',prompt:' .. yellow .. ',pointer:' .. base03 .. ',marker:' .. base03 .. ',spinner:' .. yellow,
        },
      },
    },
  }
end

return {
  'kevinhwang91/nvim-bqf',
  config = setup,
  lazy = true,
  dependencies = { 'stefandtw/quickfix-reflector.vim' },
  keys = {
    {
      '<leader>qe',
      ':lexpr[]<cr>',
      mode = 'n',
      desc = 'Clear [L]location list',
    },
    {
      '<leader>qc',
      ':cexpr[]<cr>',
      mode = 'n',
      desc = 'Clear [Q]uickFix list',
    },
    {
      '<leader>ql',
      function()
        local ft = vim.bo.filetype
        if ft == 'qf' then
          vim.cmd.lclose()
        else
          vim.cmd.lopen()
        end
      end,
      mode = 'n',
      desc = 'Toggle [L]ocation list',
    },
    {
      '<leader>qq',
      function()
        local ft = vim.bo.filetype
        if ft == 'qf' then
          vim.cmd.cclose()
        else
          vim.cmd.copen()
        end
      end,
      mode = 'n',
      desc = 'Toggle [Q]uickFix list',
    },
    {
      'q{',
      ':lnext<cr>',
      mode = 'n',
      desc = 'Pick [L]ocation next item',
    },
    {
      'q}',
      ':lprev<cr>',
      mode = 'n',
      desc = 'Pick [L]ocation prev item',
    },
    {
      'q[',
      ':cnext<cr>',
      mode = 'n',
      desc = 'Pick [Q]uickFix next item',
    },
    {
      'q]',
      ':cprev<cr>',
      mode = 'n',
      desc = 'Pick [Q]uickFix prev item',
    },
  },
}
