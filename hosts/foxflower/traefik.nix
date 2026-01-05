{
  pkgs,
  config,
  ...
}: {
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "acme@foxflower.tech";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };

      api.dashboard = true;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      # api.insecure = true;
    };

    dynamicConfigOptions = {
      
      http.routers.foxflower = {
        rule = "Host(`foxflower.tech`)";
        entrypoints = [ "websecure" ];
	service = "foxflower";
	tls = {
	  certResolver = "letsencrypt";
	  domains = ["foxflower.tech"];
	};
      };
      http.services.foxflower = {
	loadBalancer.servers = [{
	  url = "http://localhost:80";
	}];
      };

      http.routers.traefik = {
        rule = "Host(`traefik.foxflower.tech`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
        entrypoints = [ "websecure" ];
	service = "noop@internal";
	tls = {
	  certResolver = "letsencrypt";
	  domains = ["traefik.foxflower.tech"];
	};
	middlewares = ["basic-auth"];
      };

      http.routers.sonarr = {
        rule = "Host(`sonarr.foxflower.tech`)";
        entrypoints = [ "websecure" ];
        service = "sonarr";
        tls = {
          certResolver = "letsencrypt";
	  domains = ["sonarr.foxflower.tech"];
        };
      };
      http.services.sonarr = {
        loadBalancer.servers = [{
          url = "http://localhost:8989";
        }];
      };

      http.routers.radarr = {
        rule = "Host(`radarr.foxflower.tech`)";
        entrypoints = [ "websecure" ];
        service = "radarr";
        tls = {
          certResolver = "letsencrypt";
	  domains = ["radarr.foxflower.tech"];
        };
      };
      http.services.radarr = {
        loadBalancer.servers = [{
          url = "http://localhost:7878";
        }];
      };

      http.routers.nzbget = {
        rule = "Host(`nzbget.foxflower.tech`)";
        entrypoints = [ "websecure" ];
        service = "nzbget";
        tls = {
          certResolver = "letsencrypt";
	  domains = ["nzbget.foxflower.tech"];
        };
      };
      http.services.nzbget = {
        loadBalancer.servers = [{
          url = "http://localhost:6789";
        }];
      };

      http.routers.emby = {
        rule = "Host(`emby.foxflower.tech`)";
        entrypoints = [ "websecure" ];
        service = "emby";
        tls = {
          certResolver = "letsencrypt";
	  domains = ["emby.foxflower.tech"];
        };
      };
      http.services.emby = {
        loadBalancer.servers = [{
          url = "http://localhost:8096";
        }];
      };

      http.routers.portainer = {
        rule = "Host(`portainer.foxflower.tech`)";
        entrypoints = [ "websecure" ];
        service = "portainer";
        tls = {
          certResolver = "letsencrypt";
	  domains = ["portainer.foxflower.tech"];
        };
      };
      http.services.portainer = {
        loadBalancer.servers = [{
          url = "http://localhost:9000";
        }];
      };

      http.routers.authentik = {
        rule = "Host(`authentik.foxflower.tech`)";
        entrypoints = [ "websecure" ];
        service = "authentik";
        tls = {
          certResolver = "letsencrypt";
	  domains = ["authentik.foxflower.tech"];
        };
      };
      http.services.authentik = {
        loadBalancer.servers = [{
          url = "http://localhost:7000";
        }];
      };
      

      http.middlewares = {
        basic-auth = {
          basicAuth = {
	    users = ["admin:$2a$10$h/F3WurMZ1Wnv1J.MF6Wuu8xE0VyMLU56eTdcYc7FKtJPsrJOO1ai"];
	  };
	};
      };
    };
  };
}
