return {
  'rmagatti/auto-session',
  lazy = false,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>wr', '<cmd>SessionSearch<CR>', desc = 'Session [r]estore' },
    { '<leader>ws', '<cmd>SessionSave<CR>', desc = '[S]ave session' },
    { '<leader>ta', '<cmd>SessionToggleAutoSave<CR>', desc = '[T]oggle [a]utosave' },
  },
  opts = {
    bypass_save_filetypes = { 'alpha', 'dashboard' }, -- or whatever dashboard you use
    enabled = true,
    auto_save = false,
    auto_create = true,
    auto_restore = true,
    auto_restore_last_session = false,

    -- Git / Session naming
    git_use_branch_name = true,

    suppressed_dirs = { '/', '~/' },
    cwd_change_handling = false,
    session_lens = {
      picker = 'telescope',
      mappings = {
        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
        delete_session = { 'i', '<C-D>' },
        alternate_session = { 'i', '<C-S>' },
        copy_session = { 'i', '<C-Y>' },
      },

      session_control = {
        control_dir = vim.fn.stdpath 'data' .. '/auto_session/', -- Auto session control dir, for control files, like alternating between two sessions with session-lens
        control_filename = 'session_control.json', -- File name of the session control file
      },
    },
    -- Close neo-tree before saving session
    pre_save_cmds = {
      -- 'tabdo Neotree close',
      'Neotree close',
      'cclose',
    },
    -- Save quickfix list and open it when restoring the session
    save_extra_cmds = {
      function()
        local qflist = vim.fn.getqflist()
        -- return nil to clear any old qflist
        if #qflist == 0 then
          return nil
        end
        local qfinfo = vim.fn.getqflist { title = 1 }

        for _, entry in ipairs(qflist) do
          -- use filename instead of bufnr so it can be reloaded
          entry.filename = vim.api.nvim_buf_get_name(entry.bufnr)
          entry.bufnr = nil
        end

        local setqflist = 'call setqflist(' .. vim.fn.string(qflist) .. ')'
        local setqfinfo = 'call setqflist([], "a", ' .. vim.fn.string(qfinfo) .. ')'
        return { setqflist, setqfinfo, 'copen' }
      end,
    },
  },
}
