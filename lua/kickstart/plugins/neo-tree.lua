-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local function copy_path(state)
  -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
  -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local results = {
    filepath,
    modify(filepath, ':.'),
    modify(filepath, ':~'),
    filename,
    modify(filename, ':r'),
    modify(filename, ':e'),
  }

  vim.ui.select({
    '1. Absolute path: ' .. results[1],
    '2. Path relative to CWD: ' .. results[2],
    '3. Path relative to HOME: ' .. results[3],
    '4. Filename: ' .. results[4],
    '5. Filename without extension: ' .. results[5],
    '6. Extension of the filename: ' .. results[6],
  }, { prompt = 'Choose to copy to clipboard:' }, function(choice)
    if choice then
      local i = tonumber(choice:sub(1, 1))
      if i then
        local result = results[i]
        vim.fn.setreg('"', result)
        -- vim.notify('Copied: ' .. result)
      else
        -- vim.notify 'Invalid selection'
      end
    else
      -- vim.notify 'Selection cancelled'
    end
  end)
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', '<cmd>Neotree toggle<CR>', desc = 'NeoTree', silent = true },
    { '|', '<cmd>Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    auto_clean_after_session_restore = true,
    enable_git_status = true,
    enable_diagnostics = true,
    sources = { 'filesystem' },
    buffers = {
      follow_current_file = {
        enabled = false,
        leave_dirs_open = true,
      },
    },
    filesystem = {
      find_by_full_path_words = true,
      hijack_netrw_behavior = 'disabled',
      bind_to_cwd = true,
      find_command = 'fd',
      find_args = {
        fd = {
          '--exclude',
          '.git',
          '--exclude',
          'node_modules',
          '--exclude',
          'vendor',
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<space>'] = 'toggle_preview',
          ['Y'] = copy_path,
        },
      },
      find_by_name = {
        hide_openned_buffers = true,
      },
      filtered_items = {
        visible = false,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          '.git',
          'vendor',
          'node_modules',
        },
        never_show = {},
      },
      follow_current_file = {
        enabled = false,
        leave_dirs_open = false,
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
  end,
}
