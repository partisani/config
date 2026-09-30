local lib = require "lib"

local toml = (require "tomlua").encode
local read = lib.read

local conf = require "conf"

local files = {
    ["~/.config/fontconfig/fonts.conf"] = read "files/fontconfig",
    ["~/.config/user-dirs.dirs"] = read "files/userdirs",
    ["~/.rustfmt.toml"] = read "files/rustfmt",
    ["~/.clippy.toml"] = read "files/clippy",
    ["~/.config/alacritty/alacritty.toml"] = toml(conf.alacritty)
}

return {
    files = files,
}
