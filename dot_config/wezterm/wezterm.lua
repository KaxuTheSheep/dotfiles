local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.initial_rows = 50

config.default_prog = { "pwsh.exe", "-NoLogo" }
-- =============================================================================
-- APPEARANCE
-- =============================================================================

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" })
config.font_size = 13.0
config.line_height = 1.2
config.cell_width = 1.0

config.font_rules = {
	{
		intensity = "Bold",
		font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold" }),
	},
	{
		intensity = "Half",
		font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Light" }),
	},
}

config.colors = {
	foreground = "#C8B8FF",
	background = "#04040A",
	cursor_bg = "#7766FF",
	cursor_border = "#7766FF",
	cursor_fg = "#04040A",
	selection_bg = "#6478BC",
	selection_fg = "#E8D8FF",

	ansi = {
		"#04040A", -- black
		"#5268AC", -- red
		"#791E72", -- green
		"#7766FF", -- yellow
		"#B498E9", -- blue
		"#D354A1", -- magenta
		"#7766FF", -- cyan
		"#C8B8FF", -- white
	},
	brights = {
		"#6478BC", -- bright black
		"#6478BC", -- bright red
		"#8A2882", -- bright green
		"#8877FF", -- bright yellow
		"#C4A8F9", -- bright blue
		"#E364B1", -- bright magenta
		"#9988FF", -- bright cyan
		"#E8D8FF", -- bright white
	},

	-- Tab bar colours
	tab_bar = {
		background = "#04040A",
		active_tab = {
			bg_color = "#2A2A4A",
			fg_color = "#C8B8FF",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#04040A",
			fg_color = "#2A2A4A",
		},
		inactive_tab_hover = {
			bg_color = "#0D0D1A",
			fg_color = "#B498E9",
		},
		new_tab = {
			bg_color = "#04040A",
			fg_color = "#2A2A4A",
		},
		new_tab_hover = {
			bg_color = "#04040A",
			fg_color = "#7766FF",
		},
	},
}

-- Transparency
config.window_background_opacity = 0.90
config.text_background_opacity = 1.0

-- Window
config.window_padding = {
	left = 12,
	right = 12,
	top = 10,
	bottom = 10,
}
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.initial_cols = 220
config.initial_rows = 50

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
config.show_tab_index_in_tab_bar = false

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Scrollback
config.scrollback_lines = 10000
config.enable_scroll_bar = false

-- Bell
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = "CursorColor",
}

-- Rendering
config.animation_fps = 60
config.max_fps = 144
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- =============================================================================
-- KEYBINDS
-- =============================================================================

local act = wezterm.action
config.leader = {
	key = "Space",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}

config.keys = {

	-- -------------------------------------------------------------------------
	-- Pane navigation — mirrors <C-hjkl> from Neovim
	-- -------------------------------------------------------------------------
	{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
	{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },

	-- -------------------------------------------------------------------------
	-- Pane splitting — LEADER + s/v (horizontal/vertical, like vim splits)
	-- -------------------------------------------------------------------------
	{
		key = "s",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- -------------------------------------------------------------------------
	-- Pane resizing — LEADER + HJKL (shift, mirrors Neovim window resizing feel)
	-- -------------------------------------------------------------------------
	{ key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },

	-- -------------------------------------------------------------------------
	-- Pane zoom — LEADER + z (toggle fullscreen pane, like Neovim <C-w>z)
	-- -------------------------------------------------------------------------
	{
		key = "z",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},

	-- -------------------------------------------------------------------------
	-- Pane close — LEADER + x
	-- -------------------------------------------------------------------------
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = false }),
	},

	-- -------------------------------------------------------------------------
	-- Tab management — LEADER + c (new), LEADER + n/p (next/prev)
	-- -------------------------------------------------------------------------
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},

	-- Jump to tab by number — LEADER + 1-9
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },

	-- -------------------------------------------------------------------------
	-- Copy mode — LEADER + [ (mirrors tmux prefix + [ for scroll/copy)
	-- -------------------------------------------------------------------------
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},

	-- -------------------------------------------------------------------------
	-- Search — LEADER + f
	-- -------------------------------------------------------------------------
	{
		key = "f",
		mods = "LEADER",
		action = act.Search({ CaseSensitiveString = "" }),
	},

	-- -------------------------------------------------------------------------
	-- Font size — CTRL + = / - / 0
	-- -------------------------------------------------------------------------
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },

	-- -------------------------------------------------------------------------
	-- Clipboard — consistent with system expectations
	-- -------------------------------------------------------------------------
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

	-- -------------------------------------------------------------------------
	-- Rename tab — LEADER + r
	-- -------------------------------------------------------------------------
	{
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Rename tab:",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- Mouse bindings
config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true

-- =============================================================================
-- RETURN
-- =============================================================================

return config
