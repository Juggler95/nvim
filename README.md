# Neovim configuration

This is my personal Neovim configuration, based on
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It uses
[lazy.nvim](https://github.com/folke/lazy.nvim) for plugins, Mason for external
development tools, the built-in Neovim LSP client, Blink for completion, and
Conform for formatting.

## Installation

Back up an existing configuration before cloning this one.

### Linux and macOS

```sh
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/Juggler95/nvim.git ~/.config/nvim
nvim
```

### Windows (PowerShell)

```powershell
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
git clone https://github.com/Juggler95/nvim.git $env:LOCALAPPDATA\nvim
nvim
```

The move command can be skipped when there is no existing configuration. On
the first launch, lazy.nvim installs the configured plugins and Mason begins
installing configured language tools.

## Requirements

- A recent Neovim release (this configuration currently targets Neovim 0.12)
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`)
- [fd](https://github.com/sharkdp/fd)
- Node.js and npm
- `make`, `unzip`, and a C compiler for native plugins and Treesitter parsers
- A Nerd Font configured in the terminal for icons
- A platform clipboard provider when Neovim does not have native clipboard
  integration

tmux and `tmux-sessionizer` are optional. Their shortcut is only created when
both commands are installed.

After installation, run these inside Neovim to check the setup:

```vim
:checkhealth
:checkhealth kickstart
:Lazy
:Mason
```

## Where to change things

| What to change | File |
| --- | --- |
| Leader key and Nerd Font setting | `init.lua` |
| Editor behavior, indentation, line numbers, clipboard, splits | `lua/options.lua` |
| General keyboard shortcuts and autocommands | `lua/keymaps.lua` |
| Enabled plugin modules | `lua/lazy-plugins.lua` |
| Language servers and Mason-installed tools | `lua/kickstart/plugins/lspconfig.lua` |
| Formatters and format-on-save behavior | `lua/kickstart/plugins/conform.lua` |
| Completion, snippets, and completion keys | `lua/kickstart/plugins/blink-cmp.lua` |
| Treesitter parsing and syntax highlighting | `lua/kickstart/plugins/treesitter.lua` |
| Optional standalone linting | `lua/kickstart/plugins/lint.lua` |
| Telescope search behavior and search shortcuts | `lua/kickstart/plugins/telescope.lua` |
| Default color scheme | `lua/kickstart/plugins/tokyonight.lua` |
| Additional color schemes | `lua/custom/plugins/colors.lua` |
| Personal plugins | `lua/custom/plugins/*.lua` |
| Exact plugin versions | `lazy-lock.json` (normally managed by lazy.nvim) |

### Changing the color scheme

Tokyo Night is selected in `lua/kickstart/plugins/tokyonight.lua`. Cyberdream
is also installed and can be tested immediately with:

```vim
:colorscheme cyberdream
```

To make another installed scheme the default, change the `vim.cmd.colorscheme`
line in `tokyonight.lua`. To add a new theme permanently, create another plugin
specification in `lua/custom/plugins/`, then select its scheme after it loads.

### Adding a plugin

Create a descriptive file under `lua/custom/plugins/`. For example:

```lua
-- lua/custom/plugins/example.lua
return {
  'owner/plugin-name',
  opts = {},
}
```

Files in that directory are imported automatically. Restart Neovim or run
`:Lazy sync`. Prefer one file per plugin or closely related group of plugins.

To temporarily disable a plugin without deleting its configuration, add:

```lua
enabled = false,
```

## Adding support for a language

Language support is made of separate layers. A language may need all of them,
but adding an LSP is usually enough to get diagnostics, navigation, hover
information, and completion.

1. Confirm the Neovim filetype

   Open a file in the language and run:

   ```vim
   :set filetype?
   ```

   Use the reported value when configuring formatters or linters. It is not
   always identical to the language name.

2. Add the language server

   Open `lua/kickstart/plugins/lspconfig.lua` and add the server to the
   `servers` table:

   ```lua
   local servers = {
     -- Existing servers...
     gopls = {},
   }
   ```

   Server names come from nvim-lspconfig. Run `:help lspconfig-all` to see the
   available names and settings. Servers in this table are passed to Mason's
   tool installer and enabled through Neovim's LSP client automatically.

   Restart Neovim, open a matching source file, and verify it with:

   ```vim
   :Mason
   :LspInfo
   :checkhealth vim.lsp
   ```

3. Completion normally needs no language-specific configuration

   Blink is already configured to use the `lsp`, `path`, and `snippets`
   sources. Once a language server attaches, its completion suggestions become
   available automatically.

   Useful completion keys:

   - `Ctrl-Space`: open completion or documentation
   - `Ctrl-n` / `Ctrl-p`: next or previous suggestion
   - `Ctrl-y`: accept a suggestion
   - `Ctrl-e`: close the completion menu
   - `Ctrl-k`: toggle signature help

   Premade snippets are supplied by `friendly-snippets`. Add a dedicated Blink
   source or LuaSnip configuration only when a language needs something beyond
   LSP completion and the existing snippets.

4. Add a formatter

   Find the formatter name supported by Conform with `:ConformInfo`, then add
   the Neovim filetype to `formatters_by_ft` in
   `lua/kickstart/plugins/conform.lua`:

   ```lua
   formatters_by_ft = {
     -- Existing formatters...
     go = { 'gofmt' },
   }
   ```

   To format that language automatically when saving, also add its filetype to
   `enabled_filetypes` in the same file:

   ```lua
   local enabled_filetypes = {
     lua = true,
     python = true,
     go = true,
   }
   ```

   If the formatter is available through Mason, add its Mason package name to
   `ensure_installed` in `lua/kickstart/plugins/lspconfig.lua`:

   ```lua
   vim.list_extend(ensure_installed, {
     'stylua',
     'some-formatter-package',
   })
   ```

   Otherwise, install the formatter with the operating system or language
   package manager and ensure its executable is on `PATH`. `<leader>f` formats
   the current buffer manually.

5. Add optional standalone linting

   An LSP often already provides diagnostics, so a separate linter is only
   needed when it adds useful checks. First enable the lint module in
   `lua/lazy-plugins.lua`:

   ```lua
   require 'kickstart.plugins.lint',
   ```

   Then add an entry using the Neovim filetype in
   `lua/kickstart/plugins/lint.lua`:

   ```lua
   lint.linters_by_ft = {
     markdown = { 'markdownlint' },
     python = { 'ruff' },
   }
   ```

   Install the linter through Mason by adding its package to
   `ensure_installed`, or install it externally and put it on `PATH`. The
   configured lint plugin runs when entering a buffer, after saving, and after
   leaving Insert mode.

6. Treesitter syntax support is automatic when available

   The Treesitter configuration attempts to install an available parser when a
   new filetype is opened. If automatic installation fails, use:

   ```vim
   :TSInstall language-name
   :checkhealth vim.treesitter
   ```

   Treesitter requires a working C compiler. Some parser names differ from
   Neovim filetypes, so check `:TSInstallInfo` when unsure.

### Example checklist

For a new language, the usual process is:

- Add its server to `servers` in `lspconfig.lua`.
- Restart and confirm the server in `:Mason` and `:LspInfo`.
- Let Blink consume the LSP completion automatically.
- Add its formatter to Conform and optionally enable format-on-save.
- Add a standalone linter only if the LSP diagnostics are insufficient.
- Open a source file and confirm Treesitter highlighting works.

### QML and Quickshell support

QML support is configured with the `qmlls` language server, Blink completion,
the `qmljs` Treesitter parser, and Qt's `qmlformat` formatter. QML and QMLJS
files are formatted automatically when saved.

Quickshell needs a machine-specific QML language-server configuration. In the
root of each Quickshell configuration, next to `shell.qml`, create an empty
`.qmlls.ini` file:

```sh
touch .qmlls.ini
```

Start Quickshell once with that configuration. Quickshell will populate the
file with the correct import paths. Add `.qmlls.ini` to that project's
`.gitignore` because its generated contents are specific to the computer.

Use these commands to diagnose QML support:

```vim
:set filetype?
:LspInfo
:ConformInfo
:checkhealth vim.lsp
```

The detected filetype should be `qml` or `qmljs`, and `qmlls` should appear as
an attached language server.

## Maintenance

- `:Lazy update` updates plugins.
- `:Lazy sync` installs missing plugins and removes plugins no longer declared.
- `:Mason` shows installed and available development tools.
- `:ConformInfo` explains which formatter is selected for the current buffer.
- `:LspInfo` shows language servers attached to the current buffer.
- Commit `lazy-lock.json` to reproduce the same plugin revisions on another
  computer.

After changing the configuration, restart Neovim and run `:checkhealth` if
anything behaves unexpectedly.
