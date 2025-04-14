return {
  'ahmedkhalf/project.nvim',
  lazy = false,
  config = function()
    require('project_nvim').setup {
      show_hidden = true,
      -- detection_methods = { 'lsp' },
      detection_methods = { 'lsp', 'pattern' },
      -- root fot php projects with priority to composer file for monorep
      patterns = { 'composer.json', '.git', 'Makefile', 'docker-compose.yml' },
    }
    local has_telescope, telescope = pcall(require, 'telescope')

    if has_telescope then
      pcall(telescope.load_extension, 'projects')
    end
  end,
}
