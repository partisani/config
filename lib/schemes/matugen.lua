local lib = require "lib"

return function(name)
    os.execute("matugen image --type scheme-smart --mode smart --source-color-index 0 --json hex " .. name .. " > /tmp/matugen")
    local json = (require "cjson").decode(lib.read("/tmp/matugen"))

    local slug = name:match(".+/(.+)%..+")

    local theme = {
        name = slug,
        slug = slug,
        author = "generated",
        description = "scheme generated from " .. name,
        variant = json.mode
    }

    for i = 0, 15 do
        local base = ("base0%X"):format(i)
        theme[base] = lib.color.from_hex(json.base16[base:lower()].default.color)
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
