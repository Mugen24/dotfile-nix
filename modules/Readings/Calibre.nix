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
        ];
        services.calibre-server = {
            enable = true;
        };
    }
