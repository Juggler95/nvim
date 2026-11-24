-- claudecode.nvim: integrates the Claude Code CLI with Neovim.
-- It runs a local WebSocket server that Claude Code connects to (the same
-- protocol the official VS Code extension uses), so Claude can see your
-- current file/selection, and proposed edits open as native Neovim diffs.
--
-- Requires the `claude` CLI on your PATH. Check with `:checkhealth claudecode`.
--
-- Keymaps live under <leader>c because <leader>a is used by Harpoon
-- (the which-key group is declared in kickstart/plugins/which-key.lua).
return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  -- Load shortly after startup (not on first keypress) so the server is
  -- running and the :ClaudeCode* commands exist right away. That also lets a
  -- `claude` started in another terminal connect to this Neovim with /ide.
  event = 'VeryLazy',
  opts = {
    -- Jump into the Claude window after sending a selection/file to it.
    focus_after_send = true,
    -- Start Claude at the git root of the current file, so it sees the whole
    -- project even if Neovim's working directory is a subfolder.
    git_repo_cwd = true,
    terminal = {
      -- snacks.nvim runs the terminal. It puts you in insert mode whenever you
      -- enter the Claude window (<A-l>, <C-w>l, mouse), and a quick double
      -- <Esc> leaves terminal mode; a single <Esc> goes straight to Claude
      -- (e.g. to interrupt it).
      provider = 'snacks',
      split_side = 'right',
      split_width_percentage = 0.35,
      -- Narrow Claude while a diff is open, so the two diff panes get room.
      diff_split_width_percentage = 0.25,
    },
  },
  keys = {
    -- Window and sessions
    { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = 'Toggle [C]laude' },
    { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', desc = '[F]ocus Claude' },
    { '<leader>cr', '<cmd>ClaudeCode --resume<cr>', desc = '[R]esume Claude session' },
    { '<leader>cC', '<cmd>ClaudeCode --continue<cr>', desc = '[C]ontinue last Claude session' },
    { '<leader>cm', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude [M]odel' },

    -- Context
    { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current [B]uffer to Claude' },
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[S]end selection to Claude' },
    {
      '<leader>cs',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file to Claude',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },

    -- Diffs (when Claude proposes an edit)
    { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[A]ccept Claude diff' },
    { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = '[D]eny Claude diff' },
    { '<leader>cD', '<cmd>ClaudeCodeCloseAllDiffs<cr>', desc = 'Close all Claude [D]iffs' },
  },
}
