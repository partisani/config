local lib = require "lib"
local yaml = require "lyaml"

--- @param name string
return function(name)
    local tbl = yaml.load(lib.read(name))

    local theme = {
        system = tbl.system,
        name = tbl.name,
        slug = tbl.slug,
        author = tbl.author,
        description = tbl.description,
        variant = tbl.variant,
    }

    lib.iter.wrap(pairs(tbl.palette))
        :map(function(k, v) return k, lib.color.from_hex(v) end)
        :foreach(function(k, v) theme[k] = v end)

    if tbl.system == "base16" then
        theme.base10 = theme.base00
        theme.base11 = theme.base00
        theme.base12 = theme.base08
        theme.base13 = theme.base0A
        theme.base14 = theme.base0B
        theme.base15 = theme.base0C
        theme.base16 = theme.base0D
        theme.base17 = theme.base0E
    end

    return theme
end
