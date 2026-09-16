local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- 指定軸で pane の位置・サイズを取り出すための対応表
local AXIS = {
  x = { pos = "left", size = "width", total = "cols", fwd = "Right", back = "Left" },
  y = { pos = "top", size = "height", total = "rows", fwd = "Down", back = "Up" },
}

local function find_pane(panes, pane_id)
  for _, p in ipairs(panes) do
    if p.pane:pane_id() == pane_id then
      return p
    end
  end
end

-- 自分 (self) と直交軸で重なっている pane を、位置ごとにまとめて並べる
-- 例) x 軸なら「自分と縦方向に重なる pane」を left の値ごとにグループ化 = 横に並ぶ列の一覧
-- 戻り値: { { pos = 10, size = 40, panes = {...} }, ... } を pos 順に
local function lanes(tab, self_id, axis)
  local a = AXIS[axis]
  local cross = axis == "x" and AXIS.y or AXIS.x
  local panes = tab:panes_with_info()
  local self = find_pane(panes, self_id)
  if not self then
    return {}
  end
  local s_start = self[cross.pos]
  local s_end = s_start + self[cross.size]

  local by_pos = {}
  for _, p in ipairs(panes) do
    local p_start = p[cross.pos]
    local p_end = p_start + p[cross.size]
    if p_start < s_end and p_end > s_start then
      local lane = by_pos[p[a.pos]]
      if not lane then
        lane = { pos = p[a.pos], size = p[a.size], panes = {} }
        by_pos[p[a.pos]] = lane
      end
      table.insert(lane.panes, p)
    end
  end

  local list = {}
  for _, lane in pairs(by_pos) do
    table.insert(list, lane)
  end
  table.sort(list, function(l, r)
    return l.pos < r.pos
  end)
  return list
end

local function adjust(window, p, dir, n)
  p.pane:activate()
  window:perform_action(act.AdjustPaneSize({ dir, n }), p.pane)
end

-- 列 i と i+1 の境界を delta セル (正: 前方, 負: 後方) 動かす
-- AdjustPaneSize は「その pane から見て最も近い同軸の分割線」を動かすため、
-- どの pane が目的の境界を担当するかは分からない。
-- そこで候補 pane に 1 セルだけ試し打ちし、列 i のサイズが期待通り変わったものを採用する
local function move_divider(window, tab, self_id, axis, i, delta)
  local a = AXIS[axis]
  local dir = delta > 0 and a.fwd or a.back
  local undo = delta > 0 and a.back or a.fwd
  local step = delta > 0 and 1 or -1
  local n = math.abs(delta)

  local current = lanes(tab, self_id, axis)
  local candidates = {}
  for _, p in ipairs(current[i].panes) do
    table.insert(candidates, p)
  end
  for _, p in ipairs(current[i + 1].panes) do
    table.insert(candidates, p)
  end

  for _, p in ipairs(candidates) do
    local before = lanes(tab, self_id, axis)[i].size
    adjust(window, p, dir, 1)
    local after = lanes(tab, self_id, axis)[i].size
    if after == before + step then
      if n > 1 then
        adjust(window, p, dir, n - 1)
      end
      return true
    end
    -- 別の境界が動いた (or 動かなかった) ので戻す
    adjust(window, p, undo, 1)
  end
  return false
end

-- axis 方向に並んだ pane を等分する
local function balance_axis(window, tab, self_id, axis)
  local a = AXIS[axis]
  local n = #lanes(tab, self_id, axis)
  if n < 2 then
    return
  end

  -- 区切り線 1 セル分を引いた上で等分
  local total = tab:get_size()[a.total]
  local target = math.floor((total - (n - 1)) / n)

  for i = 1, n - 1 do
    local delta = target - lanes(tab, self_id, axis)[i].size
    if delta ~= 0 then
      move_divider(window, tab, self_id, axis, i, delta)
    end
  end
end

-- アクティブ pane と同じ行 / 列にある pane を等幅・等高に揃える
function M.balance_panes(window, pane)
  local tab = window:active_tab()
  local self_id = pane:pane_id()
  balance_axis(window, tab, self_id, "x")
  balance_axis(window, tab, self_id, "y")
  pane:activate()
end

-- pane が閉じたら残りを自動で等分する
-- WezTerm に「pane が閉じた」イベントは無いので、update-status のたびにタブ内の pane 数を見て
-- 減っていたら等分する (シェル終了 / LEADER+x の確認後 / CLI からの kill いずれも拾える)
local pane_counts = {}

function M.watch_pane_close()
  wezterm.on("update-status", function(window, pane)
    local tab = window:active_tab()
    if not tab then
      return
    end
    local tab_id = tab:tab_id()
    local n = #tab:panes()
    local prev = pane_counts[tab_id]
    pane_counts[tab_id] = n
    if prev and n < prev and n >= 2 then
      M.balance_panes(window, window:active_pane())
    end
  end)
end

return M
