{config, pkgs, ...}: 

let
	plugin_path = ".zsh_plugins";
in {
	# Allow z-jump a smarter cd 
	programs.zoxide = {
		enable = true;
	  enableZshIntegration = true	;
	};

	home.packages = with pkgs; [
		zsh-vi-mode
	  zsh-autosuggestions
	];
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		plugins = [
			{
				name = "zsh-vi-mode";
				src = pkgs.zsh-vi-mode;
				file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
			}

			{
				name = "zsh-autosuggestions";
				src = pkgs.zsh-vi-mode;
				file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
			}
		];

		initExtra = ''
			ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
			#CALIBRE_DEVELOP_FROM=/home/mugen/App/calibre/src
			#CALIBRE_RESOURCES_PATH=/home/mugen/App/calibre/src
			#CALIBRE_PYTHON_PATH=/nix/store/5w07wfs288qpmnvjywk24f3ak5k1np7r-python3-3.11.9/bin/python
		'';
	};

}
