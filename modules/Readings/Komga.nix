{ pkgs, user, ... }: 
let 
    #TODO: make this configurable
    mangaPath = "/media/Linux_storage/Media/Readings/Comics";
    #source: https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json
    # https://github.com/keiyoushi/extensions
in
    {
        environment.systemPackages = [
            # TODO: fix hakuneko --no-sandbox to run
            pkgs.hakuneko
            pkgs.komga
            pkgs.suwayomi-server
        ];

        # services.komga = {
        #     enable = true;
        #     user = user;
        #     stateDir = "/var/lib/komga";
        #     port = 9111;
        #     openFirewall = true;
        # };

        services.flaresolverr = {
            enable = true;
            openFirewall = true;
            port = 9122;
            package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw;
        };

        services.suwayomi-server = {
             enable = true;
             user = user;
             settings = {
                 server = {
                     downloadAsCbz = true;
                     rootDir = mangaPath;
                     downloadsPath = mangaPath;
                     port = 8111;
                     # ip = "127.0.0.1";
                     ip = "192.168.0.36";
                 };
             };
        };
    }
