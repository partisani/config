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

function iter:map(fn, ...)
    return iter.new(function(state)
        local values = { state.from:next() }
        if #values == 0 then return end

        local args = { table.unpack(state.args) }
        for _, x in ipairs(values) do
            table.insert(args, x)
        end

        return fn(table.unpack(args))
    end, { from = self, args = {...} })
end

function iter:inspect(fn, ...)
    return iter.new(function(state)
        local values = { state.from:next() }
        if #values == 0 then return end

        local args = { table.unpack(state.args) }
        for _, x in ipairs(values) do
            table.insert(args, x)
        end

        fn(table.unpack(args))

        return table.unpack(args)
    end, { from = self, args = {...} })
end

function iter:flatten()
    return iter.new(function(state)
        -- if queue, return from queue
        if #state.queue ~= 0 then return table.remove(state.queue, 1) end

        local results = { state.from:next() }
        if #results == 0 then return end

        local ret = table.remove(results, 1)
        -- items remain, add to queue
        if #results ~= 0 then
            for _, x in ipairs(results) do
                table.insert(state.queue, x)
            end
        end

        return ret
    end, { from = self, queue = {} })
end

function iter:filter(fn)
    return iter.new(function(state)
        while true do
            local results = { state.from:results() }
            -- if iterator ends early
            if #results == 0 then return end
            local computed = fn(table.unpack(results))
            if computed then return table.unpack(results) end
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

return iter
