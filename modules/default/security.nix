{ libs, ... }:

{
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
}
