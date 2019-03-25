local magick = require "magick"
local function get_size(path,width,height)

    if width  > 12 then
        width = 12
    end

    if height > 12 then
        height = 12
    end

    if width == 0 or height == 0 then
        local img = assert(magick.load_image(path))

        if width == 0 then width  = img:get_width() end

        if height == 0 then height  = img:get_height() end
    end

    return width,height
end

local file_path = '/data/1.jpg';
local width  = 0
local height = 0
local width,height = get_size(file_path,width,height)

print(width)
print(height)

--local img = assert(magick.load_image("/data/1.jpg"))
--print("width:", img:get_width(), "height:", img:get_height());