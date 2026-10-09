local lib = require "lib"

local toml = (require "tomlua").encode
local files = setmetatable({}, {
    __index = function(_, key) return lib.read("files/" .. key) end
})

local conf = require "conf"

local syncfiles = {
    [os.getenv "HOME"] = {
        [".config"] = {
            ["fontconfig/fonts.conf"]    = files.fontconfig,
            ["kak/kakrc"]                = files.kakrc,
            ["kitty/kitty.conf"]         = files.kitty,
            ["user-dirs.dirs"]           = files.userdirs,
        },
        [".rustfmt.toml"] = files.rustfmt,
        [".clippy.toml"] = files.clippy,
        [".fvwm"] = {
            ["config"] = files.fvwm
        },
    },
    __config = { min_depth = 2, }
}

return {
    files = syncfiles,
}
