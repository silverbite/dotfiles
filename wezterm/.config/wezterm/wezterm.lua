-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.enable_scroll_bar = false
config.exit_behavior = "CloseOnCleanExit"

config.font = wezterm.font("Mononoki Nerd Font", { weight = "Bold" })
config.font_size = 13
config.font_rules = {
	{
		intensity = "Bold",
		font = wezterm.font("Mononoki Nerd Font", { weight = "Bold" }),
	},
}

config.color_scheme = "One Light (base16)"
config.line_height = 1.25
config.native_macos_fullscreen_mode = false
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = "RESIZE"

config.window_frame = {
	font = require("wezterm").font("Roboto"),
	font_size = 13,
}

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.window_padding = {
	left = 8,
	right = 0,
	top = 8,
	bottom = 0,
}

config.colors = {
	tab_bar = {
		-- The color of the strip that goes along the top of the window
		-- (does not apply when fancy tab bar is in use)
		background = "#383A42",

		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = "#50A14F",
			-- The color of the text for the tab
			fg_color = "#090A0B",

			-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
			-- label shown for this tab.
			-- The default is "Normal"
			intensity = "Normal",

			-- Specify whether you want "None", "Single" or "Double" underline for
			-- label shown for this tab.
			-- The default is "None"
			underline = "None",

			-- Specify whether you want the text to be italic (true) or not (false)
			-- for this tab.  The default is false.
			italic = false,

			-- Specify whether you want the text to be rendered with strikethrough (true)
			-- or not for this tab.  The default is false.
			strikethrough = false,
		},

		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = "#383A42",
			fg_color = "#50A14F",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		inactive_tab_hover = {
			bg_color = "#383A42",
			fg_color = "#C18401",
			italic = true,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab_hover`.
		},

		-- The new tab button that let you create new tabs
		new_tab = {
			bg_color = "#383A42",
			fg_color = "#C18401",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			bg_color = "#383A42",
			fg_color = "#C18401",
			italic = true,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab_hover`.
		},
	},
}

config.leader = { mods = "CTRL", key = "Space", timeout_milliseconds = 1000 }

config.keys = {
	{ mods = "CMD", key = "m", action = wezterm.action.DisableDefaultAssignment },
	{ mods = "CMD", key = "LeftArrow", action = wezterm.action.ActivateTabRelative(-1) },
	{ mods = "CMD", key = "RightArrow", action = wezterm.action.ActivateTabRelative(1) },
	{ mods = "CMD", key = "\\", action = wezterm.action.TogglePaneZoomState },
	{ mods = "LEADER", key = "v", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "h", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ mods = "CMD", key = "p", action = wezterm.action.RotatePanes("Clockwise") },
	{ mods = "SHIFT", key = "UpArrow", action = wezterm.action.ActivatePaneDirection("Up") },
	{ mods = "SHIFT", key = "DownArrow", action = wezterm.action.ActivatePaneDirection("Down") },
	{ mods = "SHIFT", key = "LeftArrow", action = wezterm.action.ActivatePaneDirection("Left") },
	{ mods = "SHIFT", key = "RightArrow", action = wezterm.action.ActivatePaneDirection("Right") },
	{ mods = "LEADER", key = "Enter", action = wezterm.action.ActivateCopyMode },
}

-- and finally, return the configuration to wezterm
return config
