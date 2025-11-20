{ lib, config, pkgs, ... }:

{
  options = {
    fish.enable = lib.mkEnableOption {
      name = "enables fish";
      default = true;
    };
  };

  config = lib.mkIf config.fish.enable {
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
   nsf = ''
     function nsf -a host
         sudo nixos-rebuild switch --flake ~/nixconfigs#$host --verbose
     end
   '';
  };

 

 };

  
}
