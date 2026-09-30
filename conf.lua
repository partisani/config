local conf = {
    scheme = ({
        tinted = require "assets.schemes.tinted-schemes"
            "assets/schemes/tinted-schemes/base16/charcoal-light.yaml",
        custom = require "assets.schemes.tinted-schemes"
            "assets/schemes/tinted-custom/argon.yaml",
    }).custom,
    font = {
        sans = "Berkeley Mono",
        serif = "Berkeley Mono",
        mono = "Berkeley Mono"
    }
}

local sch = conf.scheme

conf.alacritty = {
    font = { size = 9, normal = { family = conf.font.mono } },
    
    window = { padding = { x = 40, y = 40 } },
    
    keyboard = {
        bindings = {
            { mods = "Control", key = "Return", action = "SpawnNewInstance" }
        }
    },

    colors = {
        primary = { background = sch.base00 'hex',
                    foreground = sch.base05 'hex' },

        cursor = { text   = sch.base02 'hex',
                   cursor = sch.base07 'hex' },

        normal = { black   = sch.base00 'hex',
                   red     = sch.base08 'hex',
                   green   = sch.base0B 'hex',
                   yellow  = sch.base0A 'hex',
                   blue    = sch.base0D 'hex',
                   magenta = sch.base0E 'hex',
                   cyan    = sch.base0C 'hex',
                   white   = sch.base05 'hex' },

        bright = { black   = sch.base03 'hex',
                   red     = sch.base12 'hex',
                   green   = sch.base14 'hex',
                   yellow  = sch.base13 'hex',
                   blue    = sch.base16 'hex',
                   magenta = sch.base17 'hex',
                   cyan    = sch.base15 'hex',
                   white   = sch.base07 'hex' },

        indexed_colors = { { index = 16, color = sch.base09 'hex' },
                           { index = 17, color = sch.base0F 'hex' },
                           { index = 18, color = sch.base01 'hex' },
                           { index = 19, color = sch.base02 'hex' },
                           { index = 20, color = sch.base04 'hex' },
                           { index = 21, color = sch.base06 'hex' } }
    }
}

_G.conf = conf
_G.default_env = { conf = conf }
return conf
