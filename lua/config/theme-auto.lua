local M = {}

-- Функция детекции темы окружения
M.detect_environment_theme = function()
  local i3_theme = os.execute 'readlink -f ~/.config/i3/colors-current 2>/dev/null | grep -q solarized-light'
  if i3_theme == 0 then
    return 'light'
  end
end

-- Применение темы в Neovim
M.apply_theme = function()
  local env_theme = M.detect_environment_theme()

  -- Синхронизируем с окружением
  if env_theme == 'light' then
    vim.o.background = 'light'
    vim.cmd 'colorscheme solarized'
    vim.notify('🌞 Solarized Light', vim.log.levels.INFO)
  else
    vim.o.background = 'dark'
    vim.cmd 'colorscheme solarized'
    vim.notify('🌙 Solarized Dark', vim.log.levels.INFO)
  end
end

-- Автодетект при старте Neovim
vim.api.nvim_create_autocmd('VimEnter', {
  callback = M.apply_theme,
  once = true,
})

-- Экспортируем для ручного вызова
return M
