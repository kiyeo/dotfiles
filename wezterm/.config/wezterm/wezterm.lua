local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- 1. AESTHETICS & PERFORMANCE
config.color_scheme = 'catppuccin-macchiato'
config.font = wezterm.font('JetBrainsMono Nerd Font')

config.font_size = 13.0
config.scrollback_lines = 10000

-- Configure Alt keys on macOS
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

-- 2. RESOLVE MULTIPLEXER VISUAL CONFLICTS
-- Hides WezTerm tabs so you only see Herdr's agent-tracking spaces and workspaces
config.enable_tab_bar = false
config.window_decorations = "RESIZE" -- Borderless feel; hides redundant outer titles

-- 3. RESOLVE SHORTCUT CONFLICTS (The "Prefix Key" Fix)
-- Ensure WezTerm passes Ctrl+B directly down into Herdr's UI process
--config.disable_default_key_bindings = false
--config.keys = {
-- If you had WezTerm shortcuts bound to Ctrl+B, they are safely ignored here.
-- You can still use standard OS copy/paste inside WezTerm:
--  { key = 'c', mods = 'SUPER', action = wezterm.action.CopyTo 'Clipboard' },
--  { key = 'v', mods = 'SUPER', action = wezterm.action.PasteFrom 'Clipboard' },
--}

-- 4. MOUSE PASS-THROUGH
-- Ensures mouse clicks/drags bypass WezTerm to directly hit Herdr's split windows
--config.bypass_mouse_reporting_modifiers = 'SHIFT'

return config
