hl.config({
    general = {
        gaps_in          = 2,
        gaps_out         = 4,

        border_size      = 2,

        col              = {
            active_border   = "rgb(fcbdd8)",
            inactive_border = "rgb(343a40)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout           = "scrolling",
    },

    decoration = {
        rounding         = 0,
        rounding_power   = 1,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow           = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee15171d,
        },

        blur             = {
            enabled = true,
            size = 15,
            passes = 2,
            noise = 0.0017,
            contrast = 0.8916,
            brightness = 1.0,
            vibrancy = 0.1696,
            vibrancy_darkness = 0.0,
            new_optimizations = true,
            ignore_opacity = true,
        },
    },

    animations = {
        enabled = true,
    },
})


hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })


hl.animation({ leaf = "global", enabled = true, speed = 2.5, bezier = "easeOutQuint" })


hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "easeOutQuint" })


hl.animation({ leaf = "windows", enabled = true, speed = 2.2, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.0, bezier = "easeOutQuint", style = "popin 95%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "quick", style = "popin 95%" })


hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.5, bezier = "quick" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.2, bezier = "quick" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.8, bezier = "quick" })


hl.animation({ leaf = "layers", enabled = true, speed = 2.0, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.8, bezier = "quick", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.2, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.5, bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.2, bezier = "quick" })


hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "quick", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.5, bezier = "quick", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.5, bezier = "quick", style = "fade" })


hl.animation({ leaf = "zoomFactor", enabled = true, speed = 2.5, bezier = "quick" })
