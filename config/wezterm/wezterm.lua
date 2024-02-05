local wezterm = require("wezterm")

local config = {
	color_scheme = "Tokyo Night Moon",
	window_background_opacity = 0.9,
	font_size = 12,
	line_height = 1.0,
	font = wezterm.font("JetBrains Mono", { weight = "Regular" }),
	font_rules = {
		{
			italic = true,
			font = wezterm.font("JetBrains Mono", { weight = "Medium" }),
		},
	},
	window_frame = {
		font = wezterm.font({ family = "JetBrains Mono" }),
	},
	colors = {
		tab_bar = {
			background = "#1b1d2b",
			active_tab = {
				bg_color = "#82aaff",
				fg_color = "#1e2030",
			},
			inactive_tab = {
				bg_color = "#2f334d",
				fg_color = "#545c7e",
			},
		},
	},
	native_macos_fullscreen_mode = true,
	window_padding = {
		left = 5,
		right = 5,
	},
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
	keys = {
		{
			key = "i",
			mods = "CMD|SHIFT",
			action = wezterm.action.PromptInputLine({
				description = "Tab name",
				action = wezterm.action_callback(function(window, _, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
	}
}

return config
