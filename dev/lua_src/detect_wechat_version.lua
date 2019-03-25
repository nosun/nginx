--
-- Created by IntelliJ IDEA.
-- User: nosun
-- Date: 19-3-25
-- Time: 下午2:19
-- To change this template use File | Settings | File Templates.
--

local function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

local function split_path(str)
    return split(str,'[\\/]+')
end

local referer = ngx.req.get_headers()["Referer"]

local parts = split_path(referer)

if parts[4] == 'devtools' or parts[4] == '0' then
    return 'true'
else
    return parts[4]
end