return {
  'Jamsjz/django.nvim',
  dependencies = {
    { 'nvim-telescope/telescope.nvim' }, -- Optional
    { 'voldikss/vim-floaterm' }, -- Optional
  },
  config = function() require('django').setup() end,
}
