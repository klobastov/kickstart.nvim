return {
  'kndndrj/nvim-dbee',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  enabled = false,
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require('dbee').install()
  end,
  config = function()
    require('dbee').setup {
      sources = {
        -- require('dbee.sources').EnvSource:new('DBEE_CONNECTIONS'),
        -- require("dbee.sources").MemorySource:new({
        --     {
        --         name = "dbname",
        --         type = "postgres",
        --         url = "postgres://pguser:pguser@localhost:5602/dbname?sslmode=disable"
        --     },
        -- }),
        require('dbee.sources').FileSource:new(vim.fn.stdpath 'cache' .. '/dbee/persistence.json'),
      },
      extra_helpers = {
        ['postgres'] = {
          ['List All'] = 'select * from {{ .Table }}',
        },
      },
      editor = {
        -- mappings for the buffer
        mappings = {
          -- run what's currently selected on the active connection
          { key = '<localleader>r', mode = 'v', action = 'run_selection' },
          { key = '<C-CR>', mode = 'v', action = 'run_selection' },
          -- run the whole file on the active connection
          { key = '<localleader>r', mode = 'n', action = 'run_file' },
        },
      },
      result = {
        page_size = 30,
        { key = 'L', mode = 'n', action = 'page_next' },
        { key = 'H', mode = 'n', action = 'page_prev' },
        { key = '<C-n>', mode = 'n', action = 'page_next' },
        { key = '<C-p>', mode = 'n', action = 'page_prev' },
        { key = 'G', mode = 'n', action = 'page_last' },
        { key = 'gg', mode = 'n', action = 'page_first' },
      },
      call_log = {
        -- mappings for the buffer
        mappings = {
          -- show the result of the currently selected call record
          { key = '<CR>', mode = 'n', action = 'show_result' },
          { key = '<C-l>', mode = 'n', action = 'show_result' },
          -- cancel the currently selected call (if its still executing)
          { key = '<C-c>', mode = 'n', action = 'cancel_call' },
        },
      },
    }
  end,
}
