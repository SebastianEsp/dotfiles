-- Input
hl.config({
  input = {
    kb_layout  = "us,dk",
    kb_options = "grp:alt_shift_toggle",
    accel_profile = "flat",
    sensitivity = 0.5,
  },
})

-- Render and cursor settings
hl.config({
  render = {
    direct_scanout = 1,
    cm_auto_hdr    = 1,
    --cm_fs_passthrough = 1,
  },
  cursor = {
    use_cpu_buffer = true,
  },
})

-- Autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
  hl.exec_cmd("xrandr --output DP-6 --primary")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("padctl --config ~/.config/padctl/devices/vader5.toml")
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("[workspace special silent] kitty")
  hl.exec_cmd("[workspace 1 silent] kitty")
  hl.exec_cmd("[workspace 2 silent] firefox -P default")
  hl.exec_cmd("[workspace 10 silent] firefox -P left")
  hl.exec_cmd("[workspace 9 silent] firefox -P right")
  hl.exec_cmd("[workspace 10 silent] discord --use-gl=desktop")
  hl.exec_cmd("[workspace 9 silent] spotify")
  hl.exec_cmd("swaync")
  hl.exec_cmd("[workspace 3 silent] steam -silent")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("sh ~/wallpaper_randomizer.sh")
end)

-- Monitor rules
hl.monitor({ output = "DP-2", mode = "1920x1080",     position = "4520x0",  scale = 1, transform = 1 })
hl.monitor({ output = "DP-4", mode = "1920x1080@120", position = "0x0",     scale = 1, transform = 1 })
hl.monitor({ output = "DP-3", mode = "3440x1440@164", position = "1080x52", scale = 1,
  supports_hdr = 1, supports_wide_color = 1, vrr = 2, bitdepth = 10,
  --cm = "hdr",
  sdrbrightness = 1.4, sdrsaturation = 1.05 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Keybinds
hl.bind("SUPER + Return",    hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-sink-volume @DEFAULT_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-sink-volume @DEFAULT_SINK@ 5%-"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"))

-- Volume keyboard
hl.bind("SUPER + equal", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+"))
hl.bind("SUPER + minus", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%-"))

-- Swaync, logout, special workspace, fullscreen, screenshot
hl.bind("SUPER + n",           hl.dsp.exec_cmd("swaync-client -t -sw"))
-- hl.bind("SUPER + l",           hl.dsp.exec_cmd("~/logoutlaunch.sh"))
hl.bind("SUPER + l",           hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind("SUPER + SHIFT + Return", hl.dsp.workspace.toggle_special())
hl.bind("SUPER + f",           hl.dsp.window.fullscreen())
hl.bind("PRINT",               hl.dsp.exec_cmd("hyprshot -m region"))

-- Move focus with arrow keys
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with CTRL + arrow keys (monitor-relative)
hl.bind("CTRL + left",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind("CTRL + right", hl.dsp.focus({ workspace = "m+1" }))

-- Switch workspaces with CTRL + [0-9], move window with CTRL + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10
  hl.bind("CTRL + " .. key,         hl.dsp.focus({ workspace = i }))
  hl.bind("CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move active window to adjacent workspace
hl.bind("CTRL + ALT + left",  hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("CTRL + ALT + right", hl.dsp.window.move({ workspace = "e+1" }))

-- Window management
hl.bind("SUPER + s", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + q", hl.dsp.window.close())

-- Rofi
-- hl.bind("SUPER + space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
-- hl.bind("SUPER + tab",   hl.dsp.exec_cmd("~/rofilaunch.sh --window"))

-- Workspace rules
hl.workspace_rule({ workspace = "1",  monitor = "DP-3", default = true })
hl.workspace_rule({ workspace = "2",  monitor = "DP-3" })
hl.workspace_rule({ workspace = "3",  monitor = "DP-3" })
hl.workspace_rule({ workspace = "9",  monitor = "DP-2", gaps_out = 0, default = true, layout_opts = { orientation = "top" } })
hl.workspace_rule({ workspace = "10", monitor = "DP-4", gaps_out = 0, default = true, layout_opts = { orientation = "top" } })

-- Window rules
hl.window_rule({
  name  = "discord-updater",
  match = { title = "(Discord Updater)" },
  workspace = "10",
})
hl.window_rule({
  name  = "discord",
  match = { class = "discord" },
  workspace = "10",
})
