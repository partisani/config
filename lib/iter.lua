--- @class iterator<T, S>
--- @field protected _next fun(state: S): T?
--- @field state S
--- @module 'lib.iter'
local iter = {}

--- creates an iterator from the `next` function and arbitrary `state`
--- @generic T
--- @generic S
--- @param next function
--- @param state S
--- @return iterator 
function iter.new(next, state)
    assert(type(next) == "function", "expected `next` to be a function")
    return setmetatable({
        _next = next,
        state = state
    }, {
        __index = iter
    })
end

function iter.wrap(f, s, var)
    local var_started_as_present = var ~= nil
    return iter.new(function(state)
        if state.var == nil and var_started_as_present then return end
        local results = { state.f(state.s, state.var) }
        state.var = results[1]
        return table.unpack(results)
    end, { f = f, s = s, var = var })
end

--- @return ...T
function iter:next()
    return self._next(self.state)
end

function iter:collect()
    local tbl = {}

    while true do
        local r = { self:next() }
        if #r == 1 then table.insert(tbl, r[1])
        elseif #r == 0 then break
        else table.insert(tbl, r) end
    end

    return tbl
end

function iter:kcollect()
    local tbl = {}

    while true do
        local key, value = self:next()
        if key == nil then break end
        tbl[key] = value
    end

    return tbl
end

-- derived iterators

function iter:map(fn)
    return iter.new(function(state)
        local values = { state.from:next() }
        if #values == 0 then return end
        return fn(table.unpack(values))
    end, { from = self })
end

function iter:filter(fn)
    return iter.new(function(state)
        while true do
            local next = state.from:next()
            -- if iterator ends early
            if next == nil then return end
            local computed = fn(next)
            if computed then return next end
        end
    end, { from = self })
end

function iter:foreach(fn)
    while true do
        local results = { self:next() }
        if #results == 0 then return end
        fn(table.unpack(results))
    end
end

-- iterators from other values

--- @param s string
function string.lines(s)
    return s:gmatch("[^\n]-")
end

return iter
