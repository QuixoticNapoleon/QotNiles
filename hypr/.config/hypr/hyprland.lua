-- ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗     ███████╗ ██████╗ ███╗   ██╗
-- ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔════╝██╔═══██╗████╗  ██║
-- ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     █████╗  ██║   ██║██╔██╗ ██║
-- ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══╝  ██║   ██║██║╚██╗██║
-- ██║  ██║   ██║   ██║     ██║  ██║███████╗███████╗╚██████╔╝██║ ╚████║
-- ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝
--
-- █▄▄ █░█ ▀ █▀   █▀▀ █▀█ █▄░█ █▀▀ █ █▀▀   █▀▀ █▀█ █▀█   █░█ █▄█ █▀█ █▀█ █░░ ▄▀█ █▄░█ █▀▄
-- █▄█ █▀█ ░ ▄█   █▄▄ █▄█ █░▀█ █▀░ █ █▄▄   █▀░ █▄█ █▀▄   █▀█ ░█░ █▀▀ █▀▄ █▄▄ █▀█ █░▀█ █▄▀


-- ╔════════════════════════════════════════╗
-- ║  🖥  MONITORS                          ║
-- ╚════════════════════════════════════════╝

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


-- ╔════════════════════════════════════════╗
-- ║  📦  MY PROGRAMS                       ║
-- ╚════════════════════════════════════════╝

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "rofi -modi drun -show drun -config ~/.config/rofi/rofidmenu.rasi"
local browser     = "firefox"


-- ╔════════════════════════════════════════╗
-- ║  ⚡  AUTOSTART                         ║
-- ╚════════════════════════════════════════╝

hl.on("hyprland.start", function()
    hl.exec_cmd("kitty")
    hl.exec_cmd("kitty")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("dunst")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-paste --primary --type text --watch cliphist -db-path ~/.cache/cliphist/primary.db store")
    hl.exec_cmd("wl-paste --primary --type image --watch cliphist -db-path ~/.cache/cliphist/primary.db store")
end)


-- ╔════════════════════════════════════════╗
-- ║  🌿  ENVIRONMENT VARIABLES             ║
-- ╚════════════════════════════════════════╝

hl.env("XCURSOR_THEME", "Vimix-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Vimix-cursors")
hl.env("HYPRCURSOR_SIZE", "24")

-- Toolkit theming
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")


-- ╔════════════════════════════════════════╗
-- ║  ⌨  DEVICE                            ║
-- ╚════════════════════════════════════════╝

hl.device({
    name    = "at-translated-set-2-keyboard",
    enabled = false,
})


-- ╔════════════════════════════════════════╗
-- ║  🎨  LOOK AND FEEL                     ║
-- ╚════════════════════════════════════════╝

-- Colors (ported from bspwm)
local darkcyan    = "rgb(007575)"
local lightcyan   = "rgb(1ebaba)"
local lightercyan = "rgb(19e0e0)"
local red         = "rgb(e55235)"

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 3,

        border_size = 1,

        col = {
            active_border   = lightercyan,
            inactive_border = darkcyan,
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "scrolling",
    },
})

hl.config({
    dwindle = {
        preserve_split = true,
        force_split    = 2,
    },
})

hl.config({
    decoration = {
        rounding = 0,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled           = true,
            size              = 0,
            passes            = 5,
            ignore_opacity    = false,
            new_optimizations = true,
            xray              = false,
            vibrancy          = 0.1696,
        },
    },
})

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 4,  bezier = "default", style = "slidefade" })

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        focus_on_activate       = true,
        background_color        = 0x000000,
    },
})


-- ╔════════════════════════════════════════╗
-- ║  🖱  INPUT                             ║
-- ╚════════════════════════════════════════╝

hl.config({
    input = {
        -- kb_layout = "us,us,cn,jp,ru",
        -- kb_variant = "dvorak,,wubi,,,",
        -- kb_model = "",
        -- kb_options = "grp:ctrl_shift_toggle",
        -- kb_rules = "",
        kb_layout  = "us",
        kb_variant = "dvp",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- gestures: workspace_swipe option does not exist in current Hyprland

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


-- ╔════════════════════════════════════════╗
-- ║  ⌨  KEYBINDINGS                       ║
-- ╚════════════════════════════════════════╝

-- Applications
hl.bind("SUPER + Return",       hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + ALT + Return", hl.dsp.exec_cmd("kitty --class floating"))
hl.bind("SUPER + W",            hl.dsp.exec_cmd(browser))
hl.bind("SUPER + D",            hl.dsp.exec_cmd(menu))
hl.bind("SUPER + E",            hl.dsp.exec_cmd("emacs"))

-- Scripts
hl.bind("SUPER + V",         hl.dsp.exec_cmd("~/Scripts/clipboard"))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("~/Scripts/clipboard-primary"))
hl.bind("SUPER + R",         hl.dsp.exec_cmd("~/Scripts/run"))
hl.bind("SUPER + S",         hl.dsp.exec_cmd("~/Scripts/screenshot"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("~/Scripts/screenshot snip"))

-- Window Management
hl.bind("SUPER + SHIFT + C", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + F",         hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind("SUPER + M",         hl.dsp.window.fullscreen({ mode = 1 }))

-- Move Focus (Vim-style)
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

-- Swap Window (Vim-style)
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

-- Preselection / Split Direction (Ctrl+Super+hjkl)
hl.bind("SUPER + CTRL + H", hl.dsp.layout("preselect l"))
hl.bind("SUPER + CTRL + L", hl.dsp.layout("preselect r"))
hl.bind("SUPER + CTRL + K", hl.dsp.layout("preselect u"))
hl.bind("SUPER + CTRL + J", hl.dsp.layout("preselect d"))

-- Swap with last window
hl.bind("SUPER + CTRL + M", hl.dsp.window.swap({ prev = true }))

-- Switch Workspaces (Dvorak layout keys)
hl.bind("SUPER + ampersand",    hl.dsp.focus({ workspace = 1 }))     -- 一
hl.bind("SUPER + bracketleft",  hl.dsp.focus({ workspace = 2 }))     -- 二
hl.bind("SUPER + braceleft",    hl.dsp.focus({ workspace = 3 }))     -- 三
hl.bind("SUPER + braceright",   hl.dsp.focus({ workspace = 4 }))     -- 四
hl.bind("SUPER + parenleft",    hl.dsp.focus({ workspace = 5 }))     -- 五
hl.bind("SUPER + equal",        hl.dsp.focus({ workspace = 6 }))     -- 六
hl.bind("SUPER + asterisk",     hl.dsp.focus({ workspace = 7 }))     -- 七
hl.bind("SUPER + parenright",   hl.dsp.focus({ workspace = 8 }))     -- 八
hl.bind("SUPER + plus",         hl.dsp.focus({ workspace = 9 }))     -- 九
hl.bind("SUPER + bracketright", hl.dsp.focus({ workspace = 10 }))    -- 十
hl.bind("SUPER + exclam",       hl.dsp.focus({ workspace = 11 }))
hl.bind("SUPER + numbersign",   hl.dsp.focus({ workspace = 12 }))

-- Move to Workspace (Dvorak layout keys)
hl.bind("SUPER + SHIFT + ampersand",    hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + braceleft",    hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + braceright",   hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + parenleft",    hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + equal",        hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + asterisk",     hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + parenright",   hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + plus",         hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + bracketright", hl.dsp.window.move({ workspace = 10 }))
hl.bind("SUPER + SHIFT + exclam",       hl.dsp.window.move({ workspace = 11 }))
hl.bind("SUPER + SHIFT + numbersign",   hl.dsp.window.move({ workspace = 12 }))

-- Scroll Through Workspaces (mainMod + scroll)
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move / Resize Windows (mainMod + LMB/RMB)
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd([[pactl set-sink-volume @DEFAULT_SINK@ +5% && VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+%' | head -1) && dunstify " Volume: $VOLUME" -h int:value:"${VOLUME%\%}" -r 2593 -t 1000]]), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd([[pactl set-sink-volume @DEFAULT_SINK@ -5% && VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+%' | head -1) && dunstify " Volume: $VOLUME" -h int:value:"${VOLUME%\%}" -r 2593 -t 1000]]), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/mute"), { locked = true })


-- ╔════════════════════════════════════════╗
-- ║  🪟  LAYER RULES                       ║
-- ╚════════════════════════════════════════╝

hl.layer_rule({
    match        = { namespace = "notifications" },
    blur         = true,
    ignore_alpha = 0.59,
})

hl.layer_rule({
    match        = { namespace = "rofi" },
    blur         = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match        = { namespace = "quickshell*" },
    blur         = true,
    ignore_alpha = 0.5,
})


-- ╔════════════════════════════════════════╗
-- ║  🗂  WINDOWS AND WORKSPACES            ║
-- ╚════════════════════════════════════════╝

-- Firefox -> workspace 2
hl.window_rule({
    match     = { class = "^(firefox)$" },
    workspace = 2,
})

-- Emacs -> workspace 3
hl.window_rule({
    match     = { class = "^(Emacs)$" },
    workspace = 3,
})

-- Float windows with class "floating"
hl.window_rule({
    match = { class = "^(floating)$" },
    float = true,
})

-- Dropdown terminal (yakuake-style)
hl.window_rule({
    match = { class = "^(quickshell-dropdown)$" },
    float = true,
    size  = "100% 40%",
    move  = "0 25",
})

-- Workspace Names (Chinese characters from bspwm)
hl.on("hyprland.start", function()
    hl.exec_cmd([[hyprctl dispatch renameworkspace "1 一"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "2 二"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "3 三"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "4 四"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "5 五"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "6 六"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "7 七"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "8 八"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "9 九"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "10 十"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "11 ᚨ"]])
    hl.exec_cmd([[hyprctl dispatch renameworkspace "12 ᚠ"]])
end)
