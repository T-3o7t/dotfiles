local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- 初期値 (保存ファイルが無いとき)
M.default = "Tokyo Night"

-- LEADER+c で出すお気に入り一覧。WezTerm 同梱の名前で指定する
-- (存在しない名前は一覧から自動で除外される)
M.favorites = {
  "Tokyo Night",
  "Tokyo Night Storm",
  "Tokyo Night Moon",
  "Catppuccin Mocha",
  "Catppuccin Macchiato",
  "Kanagawa (Gogh)",
  "Gruvbox Dark (Gogh)",
  "Everforest Dark (Gogh)",
  "nord",
  "rose-pine",
  "Dracula",
  "OneDark (base16)",
}

-- 選択したスキームの保存先
local state_file = wezterm.config_dir .. "/.colorscheme"

function M.load()
  local f = io.open(state_file, "r")
  if f then
    local name = f:read("*l")
    f:close()
    if name and #name > 0 and wezterm.get_builtin_color_schemes()[name] then
      return name
    end
  end
  return M.default
end

local function save(name)
  local f = io.open(state_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

local function choices(names)
  local builtin = wezterm.get_builtin_color_schemes()
  local current = M.load()
  local list = {}
  for _, n in ipairs(names) do
    if builtin[n] then
      table.insert(list, { id = n, label = (n == current and "* " or "  ") .. n })
    end
  end
  return list
end

local function picker(title, names)
  return act.InputSelector({
    title = title,
    fuzzy = true,
    choices = choices(names),
    action = wezterm.action_callback(function(window, pane, id, label)
      if id then
        save(id)
        -- 保存した名前を wezterm.lua が読み直して全ウィンドウに反映
        wezterm.reload_configuration()
      end
    end),
  })
end

-- お気に入りから選ぶ
function M.pick_favorites()
  return picker("Color scheme", M.favorites)
end

-- 同梱の全スキームから絞り込んで選ぶ
function M.pick_all()
  local names = {}
  for n in pairs(wezterm.get_builtin_color_schemes()) do
    table.insert(names, n)
  end
  table.sort(names)
  return picker("Color scheme (all)", names)
end

return M
