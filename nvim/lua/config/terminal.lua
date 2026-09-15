-- 右側の縦分割にターミナルを出す / 隠す（バッファは保持するので再表示で続きから使える）。
-- 「ツリー | コード | claude」の 3 ペイン配置を <leader>tl で一発で作る。

local map = vim.keymap.set
local terminals = {} -- name -> bufnr

local function find_win(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end
end

--- 右端に縦分割してターミナルを開く。表示中なら隠す。
--- @param name string 識別名（同名なら同じバッファを使い回す）
--- @param cmd? string 実行コマンド（nil ならシェル）
--- @param opts? { focus?: boolean } focus=false なら開いた後に元のウィンドウへ戻る
local function toggle(name, cmd, opts)
  opts = opts or {}
  local buf = terminals[name]
  if buf and not vim.api.nvim_buf_is_valid(buf) then
    buf, terminals[name] = nil, nil
  end

  if buf then
    local win = find_win(buf)
    if win then
      vim.api.nvim_win_hide(win)
      return
    end
  end

  local prev_win = vim.api.nvim_get_current_win()
  vim.cmd("botright vsplit")
  vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.4))
  if buf then
    vim.api.nvim_win_set_buf(0, buf)
  else
    vim.cmd("terminal " .. (cmd or ""))
    buf = vim.api.nvim_get_current_buf()
    terminals[name] = buf
    vim.bo[buf].buflisted = false
  end

  if opts.focus == false then
    vim.api.nvim_set_current_win(prev_win)
  else
    vim.cmd.startinsert()
  end
end

map("n", "<leader>tt", function()
  toggle("shell")
end, { desc = "Toggle terminal (right)" })

map("n", "<leader>tc", function()
  toggle("claude", "claude")
end, { desc = "Toggle Claude Code (right)" })

-- ツリー | コード | claude
map("n", "<leader>tl", function()
  local code_win = vim.api.nvim_get_current_win()
  local claude = terminals.claude
  if not (claude and vim.api.nvim_buf_is_valid(claude) and find_win(claude)) then
    toggle("claude", "claude", { focus = false })
  end
  vim.api.nvim_set_current_win(code_win)
  vim.cmd("NvimTreeOpen")
  vim.api.nvim_set_current_win(code_win)
end, { desc = "Layout: tree | code | claude" })

-- ターミナル内からも <C-h/j/k/l> でウィンドウ移動（<Esc><Esc> でノーマルに戻る方法もある）
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Go to left window" })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Go to lower window" })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Go to upper window" })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Go to right window" })
