local terminal = "footclient"
local menu     = "fuzzel"
local mainMod  = "SUPER"

hl.bind("SUPER + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

hl.bind("SUPER + w", function()
    local current = hl.get_config("general.layout")
    local next_layout = (current == "dwindle") and "scrolling" or "dwindle"
    hl.config({ general = { layout = next_layout } })
    hl.exec_cmd("pkill -sigrtmin+8 waybar")
end)

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("footclient --class=clip ~/.local/bin/clip.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -sigusr1 waybar"))
hl.bind(mainMod .. " + E",
    hl.dsp.exec_cmd("rofimoji --selector fuzzel --prompt \"> \" --action copy --skin-tone neutral"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.local/bin/power.sh"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("footclient --class=clip ~/.local/bin/wall.sh"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("~/.local/bin/browse.sh"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/.local/bin/tmux.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("footclient -e yazi ~/Documents/note"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.local/bin/caf.sh"))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

hl.bind(mainMod .. " + CTRL + Left", hl.dsp.focus({ monitor = "left" }))
hl.bind(mainMod .. " + CTRL + Down", hl.dsp.focus({ monitor = "down" }))
hl.bind(mainMod .. " + CTRL + Up", hl.dsp.focus({ monitor = "up" }))
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.focus({ monitor = "right" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.focus({ monitor = "left" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.focus({ monitor = "down" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.focus({ monitor = "up" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.focus({ monitor = "right" }))

hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "e-1" }))

hl.bind(mainMod .. " + SHIFT + CTRL + Left", hl.dsp.window.move({ monitor = "left" }))
hl.bind(mainMod .. " + SHIFT + CTRL + Down", hl.dsp.window.move({ monitor = "down" }))
hl.bind(mainMod .. " + SHIFT + CTRL + Up", hl.dsp.window.move({ monitor = "up" }))
hl.bind(mainMod .. " + SHIFT + CTRL + Right", hl.dsp.window.move({ monitor = "right" }))

hl.bind(mainMod .. " + SHIFT + CTRL + H", hl.dsp.window.move({ monitor = "left" }))
hl.bind(mainMod .. " + SHIFT + CTRL + J", hl.dsp.window.move({ monitor = "down" }))
hl.bind(mainMod .. " + SHIFT + CTRL + K", hl.dsp.window.move({ monitor = "up" }))
hl.bind(mainMod .. " + SHIFT + CTRL + L", hl.dsp.window.move({ monitor = "right" }))

hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + U", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + I", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + Page_Up", hl.dsp.window.move({ workspace = "e-1" }))

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + Minus", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + Equal", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Minus", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Equal", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local function scroll_or_cycle(dir)
    return function()
        local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
        if not ws then return end

        if ws.tiled_layout == "scrolling" then
            local layout_dir = (dir == "next") and "focus r" or "focus l"
            hl.dispatch(hl.dsp.layout(layout_dir))
        else
            local cycle_dir = (dir == "next") and "next" or "prev"
            hl.dispatch(hl.dsp.focus({ window = cycle_dir }))
        end
    end
end
hl.bind(mainMod .. " + mouse_down", scroll_or_cycle("next"))
hl.bind(mainMod .. " + mouse_up", scroll_or_cycle("prev"))

hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "e-1" }))

hl.bind(mainMod .. " + CTRL + mouse_down", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + mouse_up", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.local/bin/vol.sh up"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.local/bin/vol.sh down"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.local/bin/vol.sh mute"),
    { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.local/bin/brightness.sh up"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.local/bin/brightness.sh down"),
    { locked = true, repeating = true })

hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -"))
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\" - | wl-copy"))
hl.bind("ALT + Print",
    hl.dsp.exec_cmd(
        "hyprctl activewindow -j | jq -r '.at,.size' | tr '\\n' ' ' | awk '{printf \"%d,%d %dx%d\",$1,$2,$3,$4}' | xargs -I{} grim -g {} - | wl-copy"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
