{config, pkgs, user, ...}: 

let
	plugin_path = ".zsh_plugins";
in 
{
	environment.defaultPackages = with pkgs; [ 
		#Terminal auto-completion
		fzf
		# zsh-fzf-tab
		eza
	];

	home-manager.users.${user} = {
		# Allow z-jump a smarter cd 
		programs.zoxide = {
		  enable = true;
		  enableZshIntegration = true	;
		};

		programs.zsh = {
			enable = true;
			enableCompletion = true;
			autosuggestion.enable = true;
			syntaxHighlighting.enable = true;
			plugins = [
				{
					name = "zsh-fzf-tab";
					src = pkgs.zsh-fzf-tab;
					file = "share/fzf-tab/fzf-tab.plugin.zsh";
				}

				{
					name = "zsh-vi-mode";
					src = pkgs.zsh-vi-mode;
					file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
				}


				# {
				# 	name = "zsh-autosuggestions";
				# 	src = pkgs.zsh-vi-mode;
				# 	file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
				# }
			];

			initExtra = ''
				ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
				#CALIBRE_DEVELOP_FROM=/home/mugen/App/calibre/src
				#CALIBRE_RESOURCES_PATH=/home/mugen/App/calibre/src
				#CALIBRE_PYTHON_PATH=/nix/store/5w07wfs288qpmnvjywk24f3ak5k1np7r-python3-3.11.9/bin/python

				zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath' # remember to use single quote here!!!
				#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # remember to use single quote here!!!
			'';
			shellGlobalAliases = {
				nt = "cd /etc/nixos; sudo nixos-rebuild test --flake .#mugen --fast";
				ns = "cd /etc/nixos; sudo nixos-rebuild switch --flake .#mugen --fast";
			};
		};

	};
}
