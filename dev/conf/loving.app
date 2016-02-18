    server {
        listen       80;
        server_name  img.lovingbridal.com

        root /data/www/image.app/upload/;
        
	# /image/300x200/99/1/feea0668c44f456789/feea0668c44fd5ea69f65fc62750de76.jpg
        location ~ "^/image/(\d+)x(\d+)/([\d]{1,3})/(\d)/([a-f0-9]{16})/([a-f0-9]{32})\.(gif|jpg|png|css)$" {
            default_type text/html;
            set $width $1;
            set $height $2;
            set $quality $3;
            set $type $4;
            set $sig $5;
            set $name $6;
            set $ext $7;
            set $h $host;
	    set $root $document_root;

            rewrite_by_lua_file "rewrite_1.lua";
        }

	location ~ ^/upload/ {
	    deny all;
	}

        location / {

            access_by_lua '
                if ngx.var.sig == "" then
                   ngx.exit(ngx.HTTP_FORBIDDEN)
                end
            ';   
	    proxy_pass http://thumbor;
        }

        access_log   /data/logs/nginx/img.access.log  main;

    }

