{
  pkgs,
  ...
}: {
    services.nginx.package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
    services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        
        virtualHosts = {
            "localhost" = {
                locations."/nzbget".proxyPass = "http://localhost:6789";
                locations."/sonarr".proxyPass = "http://localhost:8989";
                locations."/radarr".proxyPass = "http://localhost:7878";
                locations."/portainer".proxyPass = "http://localhost:8000";
                locations."/emby" = {
                    extraConfig = ''
                        return 302 $scheme://$host/emby/;
                    '';
                };
                locations."/emby/" = {
                    proxyPass = "http://localhost:8096";
                    proxyWebsockets = true;
                    extraConfig = ''
                        proxy_pass_request_headers on;
                        proxy_set_header Host $host;

                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                        proxy_set_header X-Forwarded-Host $http_host;

                        proxy_set_header Upgrade $http_upgrade;
                        proxy_set_header Connection $http_connection;
                        proxy_buffering off;
                    '';
                };
            };
        };   
    };
}