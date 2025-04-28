{ username, pkgs, ... }: 
let 
    #TODO: make this configurable
    downloadPath = "/media/Linux_storage/Media/Readings/Books/";
    #source: https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json
    # https://github.com/keiyoushi/extensions
in
    {
        environment.systemPackages = [
            # TODO: fix hakuneko --no-sandbox to run
            # pkgs.calibre
            pkgs.audiobookshelf
        ];
        # TODO: make this a passed variable
        services.audiobookshelf = {
            enable = true;
            port = 8113;
            openFirewall = true;
        };

        services.calibre-server = {
            enable = true;
            port = 8112;
            openFirewall = true;
        };
    }
