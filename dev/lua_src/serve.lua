local image_root, convert_bin = ngx.var.image_root,ngx.var.convert_bin
ngx.say(image_root)
ngx.say(convert_bin)

local function return_not_found(msg)
  ngx.status = ngx.HTTP_NOT_FOUND
  ngx.header["Content-type"] = "text/html"
  ngx.say(msg or "not found")
  ngx.exit(0)
end

local size = "300*300"

local source_fname = images_root .. ngx.var.uri 
--ngx.say(source_fname)
function resize()
        command = table.concat({
            convert_bin,
            source_fname,
            "/data/www/image.app/images/wm_shirley.png",
            "-gravity southeast -geometry +5+10 -composite -resize",
            size,
            ngx.var.file,
        }, " ")

--ngx.header.content_type = "text/plain";
--ngx.say(command);

    os.execute(command)
end

--ngx.header.content_type = "text/plain";
--ngx.say(command);
--resize()
