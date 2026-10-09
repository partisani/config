--- @module 'lib'
local lib = {}

if not loaded then
    loaded = true
    lib.color = require "lib.color"
    lib.iter  = require "lib.iter"
end

local LOGLEVELS = {
    ["title"] = "\x1b[1;32m(@)\x1b[0m\x1b[1m",
    ["error"] = "\x1b[31m(!)\x1b[0m",
    ["trace"] = ":::",
    ["inert"] = "\x1b[2m"
}

--- @return string
local function np(path)
    return path:gsub("~", os.getenv "HOME")
end

--- shallowly copies all fields from `src` to `dst`
--- @param src table where to copy the values from
--- @param dst table target for copying
--- @return table dst
function table.copy(src, dst)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

--- replaces all instances of `#{ <lua code> }` in `text` with the value
--- returned by `<lua code>`, optionally taking `env` as extra environment
--- with priority over `_G`.
--- @param text string the string to format
--- @param env? table extra environment
--- @param chunkname? string the chunkname to show if any code errors
--- @return string result
function lib.format(text, env, chunkname)
    local e = {}
    table.copy(_G, e)
    ---@diagnostic disable-next-line: undefined-field
    table.copy(env or _G.default_env or {}, e)
    local str =  text:gsub("#{(.-)}", function(code)
        return assert(load(code, chunkname or text, "t", e))()
    end)
    return str
end

--- reads a file from `path`, closes it, possibly formats it with
--- [`format`] (unless `plain` is `true`) and returns the text
--- @param path string path to file
--- @param plain? boolean `true` if should be formatted
--- @return string? content file contents
function lib.read(path, plain)
    local file = assert(io.open(np(path), "r"))
    local text = file:read("a")
    file:close()
    if plain then return text end
    return lib.format(text)
end

--- writes `text` to `file`
--- @param path string path to file
--- @param text string new contents of file
--- @return boolean|nil error true if an error ocurred
--- @return any message error message, if any
function lib.write(path, text)
    local file, err = io.open(np(path), "w+")
    if not file then return nil, err end
    file:write(text)
    file:close()
    return true
end

--- logs with specified `level` to `stderr` with the same formatting
--- as `fprintf`. if no other arguments are provided, returns a closure
--- that does the logging with the desired `level`
--- @param level string the desired level
function lib.log(level, ...)
    local f = function(...)
        io.stderr:write(LOGLEVELS[level] or level, "\t",
                        string.format(...), "\x1b[0m\n")
    end

    if #{...} == 0 then return f
    else f(...) end
end

--- logs using `log` and quits the program with status `1` if `expr` is false,
--- passing `...` to [`string.format`] for formatting.
--- @generic T
--- @param expr T assertion
--- @param ... any
--- @return T
function lib.assert(expr, ...)
    if not expr then
        local msg = {...}
        if #msg == 0 then msg = { "assertion failed!" } end
        lib.log "error" (table.unpack(msg))
        lib.log "error" (debug.traceback("details:", 2))
        os.exit(1)
    end
    return expr
end

--- executes command and captures its output
--- @param command string the command to run
--- @param raw boolean|nil if the output should be processed
function lib.capture(command, raw)
    -- from https://stackoverflow.com/a/326715
    local f = assert(io.popen(command, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

return lib
