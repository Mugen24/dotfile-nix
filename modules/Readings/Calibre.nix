{ user, pkgs, ... }: 
let 
    #TODO: make this configurable
    downloadPath = "/media/Linux_storage/Media/Readings/Books/";
    #source: https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json
    # https://github.com/keiyoushi/extensions
    host = "192.168.0.36";
in
    {
        environment.systemPackages = [
            # TODO: fix hakuneko --no-sandbox to run
            # pkgs.calibre
            # pkgs.audiobookshelf
        ];
        # TODO: make this a passed variable
        # services.audiobookshelf = {
        #     enable = true;
        #     port = 8113;
        #     openFirewall = true;
        #     host = "192.168.0.36";
        # };

        services.kavita = {
             enable = true;
             settings.Port = 8114;
             settings.IpAddresses = host;
             tokenKeyFile = "/home/${user}/.local/state/test/kavita.s";
             package = pkgs.kavita;
        };

        # services.calibre-server = {
        #     enable = true;
        #     port = 8112;
        #     openFirewall = true;
        # };
        networking.firewall = {
            allowedTCPPorts = [ 8113 8112 8114 ];
        };
    }
