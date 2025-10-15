local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require 'telescope.actions'
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require 'telescope.actions.state'
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require('neo-tree.sources.filesystem').navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  lazy = false,
  tag = '3.28',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', '<cmd>Neotree toggle<CR>', desc = 'NeoTree' },
    { '<C-\\>', '<cmd>Neotree reveal<CR>', desc = 'NeoTree reveal' },
  },
  opts = {
    auto_clean_after_session_restore = true,
    enable_diagnostics = false,
    enable_git_status = false,
    git_status_async = true,
    use_default_mappings = true,
    enable_modified_markers = false,
    enable_refresh_on_write = true,
    log_to_file = false,
    resize_timer_interval = -1,
    use_popups_for_input = false,
    sources = { 'filesystem', 'git_status' },
    window = {
      auto_expand_width = true,
      mappings = {
        ['<space>'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
        ['P'] = 'noop',
        ['/'] = 'noop',
        ['q'] = 'noop',
        ['<cr>'] = function(state)
          state.commands['open'](state)
          vim.cmd 'Neotree reveal'
        end,
        ['<tab>'] = function() end,
        ['@'] = 'telescope_find',
        ['$'] = 'telescope_grep',
      },
    },
    buffers = {
      follow_current_file = {
        enabled = false,
        leave_dirs_open = true,
      },
    },
    filesystem = {
      find_by_full_path_words = true,
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
          ['/'] = 'noop',
        },
      },
      commands = {
        telescope_find = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').find_files(getTelescopeOpts(state, path))
        end,
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
        end,
      },
      components = {
        -- harpoon_index = function(config, node, _)
        --   local harpoon_list = require('harpoon'):list()
        --   local path = node:get_id()
        --   local harpoon_key = vim.uv.cwd()
        --
        --   for i, item in ipairs(harpoon_list.items) do
        --     local value = item.value
        --     if string.sub(item.value, 1, 1) ~= '/' then
        --       value = harpoon_key .. '/' .. item.value
        --     end
        --
        --     if value == path then
        --       vim.print(path)
        --       return {
        --         text = string.format(' ⥤ %d', i), -- <-- Add your favorite harpoon like arrow here
        --         highlight = config.highlight or 'NeoTreeDirectoryIcon',
        --       }
        --     end
        --   end
        --   return {}
        -- end,
      },
      renderers = {
        file = {
          { 'icon' },
          { 'name', use_git_status_colors = true },
          -- { 'name' },
          -- { 'harpoon_index' }, --> This is what actually adds the component in where you want it
          -- { 'diagnostics' },
          -- { 'git_status', highlight = 'NeoTreeDimText' },
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
        -- hide_by_name = {
        --   '.git',
        --   'vendor',
        --   'node_modules',
        -- },
        never_show = {},
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
  end,
}
