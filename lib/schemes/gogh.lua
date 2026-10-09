local lib = require "lib"
local yaml = require "lyaml"

local c = lib.color

--- @param name string
return function(name)
    local tbl = yaml.load(lib.read(name))

    local theme = {
        name = tbl.name,
        slug = tbl.name
            :gsub(" ", "-")
            :gsub("[A-Z]", string.lower),
        author = tbl.author,
        variant = tbl.variant,
    }

    local fg = c.from_hex(tbl.foreground)
    local bg = c.from_hex(tbl.background)

    for i = 0, 7 do
        theme["base0" .. i] = bg:mix(fg, i / 8)
    end

    local multiplier = theme.variant.dark and 0.8 or 1.2

    theme.base11 = theme.base00 * multiplier * multiplier
    theme.base10 = theme.base00 * multiplier

    theme.base08 = c.from_hex(tbl.color_02) -- Red
    theme.base09 = c.from_hex(tbl.color_02):mix(c.from_hex(tbl.color_04), 1 / 3) -- (Orange)
    theme.base0A = c.from_hex(tbl.color_04) -- Yellow
    theme.base0B = c.from_hex(tbl.color_03) -- Green
    theme.base0C = c.from_hex(tbl.color_07) -- Cyan
    theme.base0D = c.from_hex(tbl.color_05) -- Blue
    theme.base0E = c.from_hex(tbl.color_06) -- Magenta
    theme.base0F = c.from_hex(tbl.color_02):mix(c.from_hex(tbl.color_01), 2 / 3) -- (Dark Red or Brown)

    theme.base12 = c.from_hex(tbl.color_10) -- Red
    theme.base13 = c.from_hex(tbl.color_12) -- Yellow
    theme.base14 = c.from_hex(tbl.color_11) -- Green
    theme.base15 = c.from_hex(tbl.color_15) -- Cyan
    theme.base16 = c.from_hex(tbl.color_13) -- Blue
    theme.base17 = c.from_hex(tbl.color_14) -- Magenta
   
    return theme
end
