-- vscode-neovim 用のキーマップ（init.lua で vim.g.vscode のときだけ読み込む）。
-- nvim 側（telescope / nvim-tree / LSP / gitsigns / terminal）と同じキーを VS Code のコマンドへ割り当てる。
-- gd / K / gf などは vscode-neovim が既定で VS Code の定義ジャンプ / ホバーに割り当て済み。

local vscode = require("vscode")
local map = vim.keymap.set

--- VS Code コマンドを呼ぶ関数を返す
--- @param cmd string
local function action(cmd)
  return function()
    vscode.action(cmd)
  end
end

local maps = {
  -- ウィンドウ（エディタグループ / パネル）移動（nvim では smart-splits）
  { "<C-h>", "workbench.action.navigateLeft", "Go to left window" },
  { "<C-j>", "workbench.action.navigateDown", "Go to lower window" },
  { "<C-k>", "workbench.action.navigateUp", "Go to upper window" },
  { "<C-l>", "workbench.action.navigateRight", "Go to right window" },

  -- バッファ（エディタタブ）
  { "<S-h>", "workbench.action.previousEditor", "Prev buffer" },
  { "<S-l>", "workbench.action.nextEditor", "Next buffer" },
  { "<leader>bd", "workbench.action.closeActiveEditor", "Delete buffer" },

  -- find（nvim では telescope）
  { "<leader>ff", "workbench.action.quickOpen", "Find files" },
  { "<leader><space>", "workbench.action.quickOpen", "Find files" },
  { "<leader>fg", "workbench.action.findInFiles", "Grep" },
  { "<leader>/", "workbench.action.findInFiles", "Grep" },
  { "<leader>fb", "workbench.action.showAllEditors", "Buffers" },
  { "<leader>fr", "workbench.action.openRecent", "Recent files" },
  { "<leader>fd", "workbench.actions.view.problems", "Diagnostics" },

  -- ファイルツリー（nvim では nvim-tree / oil）
  { "<leader>e", "workbench.action.toggleSidebarVisibility", "Toggle file tree" },
  { "<leader>E", "workbench.files.action.showActiveFileInExplorer", "Reveal current file in tree" },
  { "-", "workbench.files.action.showActiveFileInExplorer", "Reveal current file in tree" },

  -- LSP（nvim では LspAttach で設定）
  { "gr", "editor.action.goToReferences", "References" },
  { "gI", "editor.action.goToImplementation", "Goto implementation" },
  { "<leader>cs", "workbench.action.gotoSymbol", "Document symbols" },
  { "<leader>ca", "editor.action.quickFix", "Code action" },
  { "<leader>cr", "editor.action.rename", "Rename" },
  { "<leader>cf", "editor.action.formatDocument", "Format" },
  { "<leader>cd", "editor.action.showHover", "Line diagnostics" },
  { "]d", "editor.action.marker.next", "Next diagnostic" },
  { "[d", "editor.action.marker.prev", "Prev diagnostic" },

  -- git（nvim では gitsigns）
  { "]c", "workbench.action.editor.nextChange", "Next hunk" },
  { "[c", "workbench.action.editor.previousChange", "Prev hunk" },
  { "<leader>gp", "editor.action.dirtydiff.next", "Preview hunk" },
  { "<leader>gb", "git.blame.toggleEditorDecoration", "Blame line" },
  { "<leader>gr", "git.revertSelectedRanges", "Reset hunk" },

  -- terminal
  { "<leader>tt", "workbench.action.terminal.toggleTerminal", "Toggle terminal" },

  -- ui（nvim では colorscheme 切替）
  { "<leader>ut", "workbench.action.selectTheme", "Select color theme" },
  { "<leader>uC", "workbench.action.selectTheme", "Select color theme" },
}

for _, m in ipairs(maps) do
  map("n", m[1], action(m[2]), { desc = m[3] })
end
