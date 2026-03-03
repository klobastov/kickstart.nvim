-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin
local function normalize_path(path)
  return path:gsub('\\', '/')
end

local function normalize_cwd()
  return normalize_path(vim.loop.cwd()) .. '/'
end

local function is_subdirectory(cwd, path)
  return string.lower(path:sub(1, #cwd)) == string.lower(cwd)
end

local function split_filepath(path)
  local normalized_path = normalize_path(path)
  local normalized_cwd = normalize_cwd()
  local filename = normalized_path:match '[^/]+$'

  if is_subdirectory(normalized_cwd, normalized_path) then
    local stripped_path = normalized_path:sub(#normalized_cwd + 1, -(#filename + 1))
    return stripped_path, filename
  else
    local stripped_path = normalized_path:sub(1, -(#filename + 1))
    return stripped_path, filename
  end
end

local function path_display(_, path)
  local stripped_path, filename = split_filepath(path)
  if filename == stripped_path or stripped_path == '' then
    return filename
  end
  return string.format('%s ~ %s', filename, stripped_path)
end

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'andrew-george/telescope-themes' },
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install',
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { 'nvim-telescope/telescope-live-grep-args.nvim', version = '^1.0.0' },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<c-w>'] = 'delete_buffer',
              },
            },
          },
        },
        defaults = {
          -- file_ignore_patterns = { 'node_modules', 'vendor', 'cache' },
          file_ignore_patterns = { 'node_modules', 'cache' },
          mappings = {
            -- n = {
            -- ['<Tab>'] = false,
            -- },
            i = {
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              ['<esc>'] = require('telescope.actions').close,
              -- ['<Tab>'] = false,
            },
          },
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              width = { padding = 0 },
              height = { padding = 0 },
              preview_width = 0.5,
            },
          },
          sorting_strategy = 'ascending',
          path_display = path_display,
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = { -- extend mappings
              i = {
                ['<C-e>'] = require('telescope-live-grep-args.actions').quote_prompt(),
                -- ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt { postfix = ' --iglob ' },
                -- freeze the current list and start a fuzzy search in the frozen list
                ['<C-space>'] = require('telescope.actions').to_fuzzy_refine,
              },
            },
          },
          -- advanced_git_search = {
          -- See Config
          -- }
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'themes')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'fzf')
      -- pcall(require('telescope').load_extension, 'notify')
      pcall(require('telescope').load_extension, 'live_grep_args')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      -- Keymaps
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })

      vim.keymap.set('n', '<leader>ss', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

      -- Open buffers
      vim.keymap.set('n', '<C-c>', function()
        builtin.buffers {
          sort_mru = true, -- сортировать по недавнему использованию
          ignore_current_buffer = false, -- показывать текущий буфер
          previewer = true, -- отключить превью для буферов
          layout_config = {
            width = 0.8,
            height = 0.6,
          },
          prompt_title = 'Current buffers (recent sort)',
        }
      end, { desc = '[S]earch [I]gnored' })
      -- Add a way to search ignored files
      vim.keymap.set('n', '<leader><leader>', function()
        builtin.find_files {
          -- cwd = '~/projects/',
          hidden = true,
          no_ignore = true,
          previewer = false,
          prompt_title = 'Globally Find file (include ignored, hidden)',
          -- Change strategy to 'horizontal', 'vertical', 'center', or 'flex'
          -- layout_strategy = 'center',
          layout_config = {
            width = 0.5,
            height = 0.6,
          },
        }
      end, { desc = '[S]earch [I]gnored' })
      -- Add a way to search ignored files
      vim.keymap.set('n', '<leader>si', function()
        builtin.find_files {
          hidden = true,
          no_ignore = true,
          prompt_title = 'Find file (include ignored, hidden)',
        }
      end, { desc = '[S]earch [I]gnored' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>sc', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'Fuzzily [s]earch in [c]urrent buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      --
      vim.keymap.set('n', '<leader>sgg', function()
        local tgrep = require('telescope').extensions.live_grep_args
        tgrep.live_grep_args {
          additional_args = '-i',
          prompt_title = 'Live grep',
        }
      end, { desc = '[S]earch by [G]rep' })

      -- Live grep args shortcut
      vim.keymap.set(
        'n',
        '<leader>sw',
        "<CMD>lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor({postfix=' --no-ignore --no-config'})<CR>",
        { desc = '[S]earch word under [c]ursor' }
      )

      vim.keymap.set('n', '<leader>sgi', function()
        local tgrep = require('telescope').extensions.live_grep_args

        tgrep.live_grep_args {
          prompt_title = 'Live grep (include ignored, hidden)',
          additional_args = '-i',
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--no-ignore', -- added this, the rest above are defaults
            '--hidden',
          },
        }
      end, { desc = '[S]earch by [G]rep [I]gnored' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
