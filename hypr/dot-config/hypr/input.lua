hl.config({
    input = {
        kb_layout          = "us",
        kb_options         = "caps:escape",
        numlock_by_default = true,

        repeat_delay       = 200,
        repeat_rate        = 35,

        follow_mouse       = 1,

        sensitivity        = 0,

        touchpad           = {
            tap_to_click   = true,
            natural_scroll = true,
            scroll_factor  = 1.0,
        },
    },
})

hl.device({
    name        = "",
    sensitivity = 0.2,
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
