local magick = require "magick"
local width, height, quality, type, name, ext, host, sig, root =
tonumber(ngx.var.width), tonumber(ngx.var.height), tonumber(ngx.var.quality), tonumber(ngx.var.type),
ngx.var.name, ngx.var.ext, ngx.var.h ,ngx.var.sig, ngx.var.root

local max_width,max_height = 1684,2000
local thumbor_key = "unsafe"

local function my_split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- http not found
local function return_not_found(msg)
    ngx.status = 404
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "not found")
    ngx.exit(0)
end

-- http forbidden
local function return_forbidden(msg)
    ngx.status = 403
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "forbidden")
    ngx.exit(0)
end

-- check file if exist

local function file_exists(name)
    local f = io.open(name)
    if f then io.close(f) return true else return false end
end

-- get file path
local function get_file_path(name)
    local p1 = math.floor(tonumber(string.sub(name,1,3),16)/4)
    local p2 = math.floor(tonumber(string.sub(name,4,6),16)/4)
    return p1 .. "/" .. p2 .. "/"
end

-- check size if too big
local function get_size(path,width,height)

    if width  > max_width then
        width = max_width
    end

    if height > max_height then
        height = max_height
    end

    if width == 0 or height == 0 then
        local img = assert(magick.load_image(path))
        if width == 0 then width = img:get_width() end
        if height == 0 then height = img:get_height() end
    end

    return width,height
end

-- get filters
local function get_mark(mark,width,height)
    local mark_width

    if width > 0 and width < 300
    then mark_width = nil
    elseif width > 300 and width <= 400
    then mark_width = 300
    elseif width > 400 and width <= 500
    then mark_width = 400
    elseif width > 500 and width <= 600
    then mark_width = 600
    elseif width > 600 and width <= 800
    then mark_width = 600
    elseif width > 800 and width <= 1027
    then mark_width = 800
    elseif width > 1028
    then mark_width = 900
    end

    if mark_width then
        local pos_left = math.floor((width - mark_width)/2)
        local pos_top  = math.floor(0.5 * height)  -- about gold rate cut height of water_mark
        return ":watermark(/mark/" .. mark .. "_" .. mark_width .. ".png," .. pos_left .. "," .. pos_top .. ",0)"
    else
        return ''
    end
end

local function get_cropType(type)
    local crop = 'smart';
    if  type == 2
    then crop = 'top'
    end
    return crop;
end

local crop = get_cropType(type)
local arr  = my_split(host,'.')
local site = arr[#arr-1]


--check signature
local signature = string.sub(ngx.md5(ngx.md5(site) .. width .. height .. quality .. type .. name .. '.' ..ext),0,16)
if signature ~= sig then return_forbidden(signature) end


-- check file if exist
local file_path = get_file_path(name,ext).. name ..".".. ext
local real_path = root .. "/" .. file_path;
--if file_exists(root .."/".. file_path) == false then return_not_found(root .. "/" .. file_path) end

-- begin rewrite
local width,height = get_size(real_path,width,height)
local filter_mark = get_mark(site,width,height)
local filter_quality = ":quality(" .. quality ..")"
local filters = "filters" .. filter_mark .. filter_quality
local real_path = "/" .. thumbor_key .. "/" .. width .. "x" .. height .. "/" .. crop .. "/" .. filters .. "/" .. file_path

ngx.req.set_uri(real_path, true)
