{...}: {
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    wireplumber.extraConfig."51-set-priorities" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              node.name = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Headphones__sink";
            }
          ];
          actions = {
            update-props = {
              priority.driver = 1011; # Ensure this is higher than the default
              priority.session = 1011; # I don't think priority.session is relevant, but I'm setting it anyway
            };
          };
        }
        {
          matches = [
            {
              node.name = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink";
            }
          ];
          actions = {
            update-props = {
              priority.driver = 1010; # Higher than the internal speakers
              priority.session = 1010;
            };
          };
        }
      ];
    };
  };

  services.playerctld.enable = true;
}
