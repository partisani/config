local lib = require "lib"

return function(key)
    local theme = lib.read(key .. ".txt")

    local keys = lib.iter.wrap(theme:gmatch("[ \t]-(%w-)\t([^\n]-)\n"))
        :kcollect()

    for _, name in ipairs {
        "background",
        "foreground",
        "accent0",
        "accent1",
        "accent2",
        "accent3",
        "accent4",
        "accent5",
        "accent6",
        "accent7",
    } do
        assert(keys[name], "expected `%s.txt` to include %s", key, name)
        keys[name] = lib.color.from_hex(keys[name])
    end

    local slug = key:match(".+/(.+)%..+")

    theme = {
        name = slug,
        slug = slug,
        author = "generated",
        description = "scheme generated from " .. key,
        variant = keys.background < keys.foreground and "dark" or "light"
    }

    for i = 1, 8 do
        theme["base0" .. i - 1] = keys.background:mix(keys.foreground, 1/8 * (i - 1))
        theme["base0" .. ("%X"):format(i + 7)] = keys["accent" .. i - 1]
    end

    theme.base10 = theme.base00
    theme.base11 = theme.base00
    theme.base12 = theme.base08
    theme.base13 = theme.base0A
    theme.base14 = theme.base0B
    theme.base15 = theme.base0C
    theme.base16 = theme.base0D
    theme.base17 = theme.base0E

    return theme
end
