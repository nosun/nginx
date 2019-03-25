-- exit 403 when no matching role has been found

local iputils = require("resty.iputils")

local function return_not_found(msg)
    ngx.status = 404
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "not found")
    ngx.exit(0)
end

local function return_forbidden(msg)
    ngx.status = 403
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "not found")
    ngx.exit(0)
end

local function getClientIP()
    return ngx.var.remote_addr;
end


local clientIP = getClientIP();


if not iputils.ip_in_cidrs(clientIP, whitelist) then
    return_forbidden()
end




