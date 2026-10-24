return {
  'S1M0N38/love2d.nvim',
  enabled = false,
  version = '3.*',
  event = 'VeryLazy',
  opts = {},
  keys = {
    { '<leader>v', '', desc = 'LOVE' },
    { '<leader>vr', '<cmd>Love run<cr>', desc = 'Run LOVE' },
    { '<leader>vw', '<cmd>Love watch<cr>', desc = 'Watch LOVE' },
    { '<leader>vi', '<cmd>Love info<cr>', desc = 'Info LOVE' },
    { '<leader>vs', '<cmd>Love stop<cr>', desc = 'Stop LOVE' },
    { '<leader>vo', '<cmd>Love output<cr>', desc = 'Output panel' },
  },
}
