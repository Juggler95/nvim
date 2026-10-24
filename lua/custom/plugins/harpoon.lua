return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Add current file from harpoon menu' })
      vim.keymap.set('n', '<leader>ra', function() harpoon:list():remove() end, { desc = 'Remove current file from harpoon menu' })
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon ui toggle' })

      vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end, { desc = 'Selects first option in harpoon menu' })
      vim.keymap.set('n', '<C-j>', function() harpoon:list():select(2) end, { desc = 'Selects second option in harpoon menu' })
      vim.keymap.set('n', '<C-k>', function() harpoon:list():select(3) end, { desc = 'Selects third option in harpoon menu' })
      vim.keymap.set('n', '<C-l>', function() harpoon:list():select(4) end, { desc = 'Selects forth option in harpoon menu' })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end)
      vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end)
    end,
  },
}
