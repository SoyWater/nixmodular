{
  flake.modules.homeManager.baseConfig = {
    programs.fish.enable = true;
    programs.fish.shellAliases = {
   		".." = "cd ..";
  		"..." = "cd ../..";
  		"...." = "cd ../../../";
  		"....." = "cd ../../../../";
		
  		"configs" = "cd ~/nixconfigs";

      # convenience aliases    
   		"cp" = "cp -v";
  		"ddf" = "df -h";
  		"mkdir" = "mkdir -p";
  		"mv" = "mv -v";
  		"rm" = "rm -v";
  		"rr" = "rm -rf";
    };
    programs.fish.shellAbbrs = {
     ncg = "nix-collect-garbage";
    };
    programs.fish.functions = {
      nsf = {
        body = "sudo nixos-rebuild switch --flake ~/nixconfigs#$host --verbose";
        argumentNames = "host";
      };

      config = {
        argumentNames = "name";
        body = "nix flake init -t mytemplates && mv config.nix $name.nix";
      };

      y.body = ''
        	set tmp (mktemp -t "yazi-cwd.XXXXXX")
        	yazi $argv --cwd-file="$tmp"
        	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        		builtin cd -- "$cwd"
        	end
        	rm -f -- "$tmp"
      '';
    };
    };
}
