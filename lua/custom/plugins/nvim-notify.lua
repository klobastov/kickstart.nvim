return {
  'rcarriga/nvim-notify',
  enabled = false,
  opts = {
    background_colour = 'NotifyBackground',
    fps = 30,
    icons = {
      DEBUG = '',
      ERROR = '',
      INFO = '',
      TRACE = '✎',
      WARN = '',
    },
    level = 2,
    minimum_width = 50,
    render = 'compact',
    stages = 'slide',
    time_formats = {
      notification = '%T',
      notification_history = '%FT%T',
    },
    timeout = 500,
    top_down = true,
  },
}
