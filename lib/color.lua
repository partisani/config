--- @class color rgb color
--- @field r number
--- @field g number
--- @field b number
local color = {}

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function clamp(min, x, max)
    return math.max(min, math.min(x, max))
end

--- creates a color object from `r`, `g`, `b` values
--- @param r number
--- @param g number
--- @param b number
--- @return color
function color.new(r, g, b)
    return setmetatable({ r = r, g = g, b = b }, {
        __index = color,
        __call = color.to,
        __tostring = function(self)
            return ("rgb(%d, %d, %d)"):format(self.r, self.g, self.b)
        end,
        __lt = function(self, other)
            return self:brightness() < other:brightness()
        end,
        __le = function(self, other)
            return self:brightness() <= other:brightness()
        end
    })
end

--- creates a color object from a hex string ("#AABBCC" or "123456")
--- @param str string
--- @return color
function color.from_hex(str)
    if str:sub(1, 1) == "#" then
        str = str:sub(2)
    end

    assert(#str == 6, "%s is an invalid hex string", str)

    local r = tonumber(str:sub(1, 2), 16)
    local g = tonumber(str:sub(3, 4), 16)
    local b = tonumber(str:sub(5, 6), 16)

    return color.new(r, g, b)
end

--- mixes two colors with variable `t` defining how close the result is to each
--- one of the colors. 0.0 is fully `self` and 1.0 is fully `other`.
--- @param other color
--- @param t number
function color:mix(other, t)
    return color.new(
        lerp(self.r, other.r, t),
        lerp(self.g, other.g, t),
        lerp(self.b, other.b, t)
    )
end

--- calculates brightness through the average of `r`, `g`, `b`.
function color:brightness()
    return (self.r + self.g + self.b) / 3
end

--- @alias ColorFormat
--- | "hex"
--- | "rgb"
--- turns a color back into a desired format.
--- @param fmt ColorFormat
--- @return string
function color:to(fmt)
    if fmt == "hex" then
        local r = math.floor(clamp(0, self.r, 255))
        local g = math.floor(clamp(0, self.g, 255))
        local b = math.floor(clamp(0, self.b, 255))
        return "#" .. ("%02X"):rep(3):format(r, g, b)
    end

    if fmt == "rgb" then
        return tostring(self)
    end

    return "death and suffering"
end

return color
