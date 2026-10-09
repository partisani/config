local conf = {
    scheme =
-- [[]] require "lib.schemes.tinted"    "assets/schemes/tinted-schemes/base16/grayscale-light.yaml"
-- [[]] require "lib.schemes.tinted"    "assets/schemes/tinted-custom/eink-alt.yaml"
-- [[]] require "lib.schemes.gogh"      "assets/schemes/gogh/themes/urban.yml"
--[[]] require "lib.schemes.wallpaper" "assets/wallpapers/wallhaven-lyde92.png"
-- [[]] require "lib.schemes.matugen"   "assets/wallpapers/wallhaven-7jx17y.png"
    ,
    font = {
        sans = "JetBrains Mono",
        serif = "JetBrains Mono",
        mono = "JetBrains Mono"
    }
}

local sch --[[movement]] = conf.scheme

_G.conf = conf
_G.default_env = { conf = conf }
return conf
