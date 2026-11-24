---@module 'lazy'
---@type LazySpec
return {
  {
    -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',

    dependencies = {
      {
        -- Snippet engine
        'L3MON4D3/LuaSnip',
        version = '2.*',

        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end

          return 'make install_jsregexp'
        end)(),

        dependencies = {
          {
            -- Premade snippets
            'rafamadriz/friendly-snippets',
            config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
          },
        },

        opts = {},
      },
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- Ctrl-y accepts the current completion.
        -- Ctrl-n/Ctrl-p cycle through completions.
        -- Ctrl-space opens the completion menu.
        preset = 'default',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        -- Keep the popup menu hidden until Ctrl-space is pressed.
        menu = {
          auto_show = true,
        },

        documentation = {
          auto_show = false,
          auto_show_delay_ms = 500,
        },

        -- Show the best non-AI completion as inline ghost text.
        ghost_text = {
          enabled = true,
          show_without_selection = true,
          show_with_selection = true,
          show_with_menu = true,
          show_without_menu = true,
        },
      },

      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
        },
      },

      snippets = {
        preset = 'luasnip',
      },

      fuzzy = {
        implementation = 'lua',
      },

      signature = {
        enabled = true,
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
