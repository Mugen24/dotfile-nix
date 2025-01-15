{ config, pkgs, user, ... }:

{
	home-manager.users.${user} = {
		home.packages = with pkgs; [
			nodejs_22
			typescript
		];
	};
}

