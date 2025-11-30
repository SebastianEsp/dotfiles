{
  pkgs,
  ...
}: {
    security.acme.acceptTerms = true;
    security.acme.defaults.email = "admin+acme@foxflower.tech";
    services.nginx.package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
    services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        
        virtualHosts = {
            "foxflower.tech" = {
                forceSSL = true;
		enableACME = true;
                #serverAliases = [];
                locations."/" = {
                  #root = "/var/www";
                };
                locations."/nzbget".proxyPass = "http://localhost:6789";
                locations."/sonarr".proxyPass = "http://localhost:8989";
                locations."/radarr".proxyPass = "http://localhost:7878";
                locations."/portainer".proxyPass = "http://localhost:9000";
                locations."/emby/" = {
                    extraConfig = ''
                        return 301 $scheme://$host/emby/;
                    '';
                };
                locations."/emby" = {
                    proxyPass = "http://emby:8096";
                    proxyWebsockets = true;
                    extraConfig = ''
			proxy_headers_hash_max_size 512;
     			proxy_headers_hash_bucket_size 128; 
                        proxy_buffering off;

			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
			proxy_set_header X-Forwarded-Host $server_name;
			proxy_set_header X-Forwarded-Ssl on;
			proxy_set_header Upgrade $http_upgrade;
			proxy_set_header Connection "upgrade";
                    '';
                };
            };
        };   
    };
}
