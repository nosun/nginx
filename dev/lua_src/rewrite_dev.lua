local size ,quality, mark, name, ext = ngx.var.size, ngx.var.quality, ngx.var.mark, ngx.var.name , ngx.var.ext
local cache_dir = "/cache/"
local p1 = math.floor(tonumber(string.sub(name,1,3),16)/4)
local p2 = math.floor(tonumber(string.sub(name,4,6),16)/4)
local path =  size .. "/" .. quality .. "/" .. mark .. "/" ..p1 .. "/" .. p2 .. "/" .. name .. "." .. ext
local source_fname = cache_dir .. path

ngx.req.set_uri(source_fname, true);  
