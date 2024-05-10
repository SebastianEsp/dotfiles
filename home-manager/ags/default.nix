{pkgs, inputs, ...}: {
    imports = [ inputs.ags.homeManagerModules.default ];

    home.packages = with pkgs; [
        bun
	gtk3
    ];

    gtk = {
      enable = true;
      font.name = "Victor Mono SemiBold 12";
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
    };

    programs.ags = {
        enable = true;

        # null or path, leave as null if you don't want hm to manage the config
        #configDir = ../ags;

        # additional packages to add to gjs's runtime
        extraPackages = with pkgs; [
	    gtksourceview
            webkitgtk
            accountsservice
        ];
    };

}
