local image_root, convert_bin = ngx.var.image_root,ngx.var.convert_bin
local size = "300x300"
local source_fname = image_root .. "/upload" .. "/579/789/90cc556720aac765c24379808fc01268.jpg"

local function return_not_found(msg)
  ngx.status = ngx.HTTP_NOT_FOUND
  ngx.header["Content-type"] = "text/html"
  ngx.say(msg or "not found")
  ngx.exit(0)
end

local command = table.concat({
            convert_bin,
            source_fname,
            "-resize ",
	    size,
            "/data/www/image.app/images/wm_shirley.png",
            "-gravity southeast -geometry +5+10 -composite",
            ngx.var.file,
        }, " ")

ngx.header.content_type = "text/plain"
ngx.say(command)
ngx.say(ngx.var.file)
--os.execute(command)

--ngx.header.content_type = "text/plain";
--ngx.say(command);
