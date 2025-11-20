{ config, pkgs, host, ... }:

{
  sops.secrets."wifi/NUS_STU/identity" = {};
  sops.secrets."wifi/NUS_STU/password" = {};
  sops.secrets."wifi/Good_Internet/password" = {};

  networking.hostName = host;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    
    ensureProfiles.environmentFiles = [
      config.sops.secrets."wifi/NUS_STU/identity".path
      config.sops.secrets."wifi/NUS_STU/password".path
      config.sops.secrets."wifi/Good_Internet/password".path
    ];

    ensureProfiles.profiles = {
      "nus wifi" = {
        "802-1x" = {
          eap = "peap;";
          identity = "$NUS_STU_ID";
          password = "$NUS_STU_PSK";
          phase2-auth = "mschapv2";
        };
        connection = {
          id = "NUS_STU";
          type = "wifi";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
        wifi = {
          mode = "infrastructure";
          ssid = "NUS_STU";
        };
        wifi-security = {
          key-mgmt = "wpa-eap";
        };
      };

      "goodInternet" = {
        connection = {
          id = "Good Internet";
          type = "wifi";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
        wifi = {
          mode = "infrastructure";
          ssid = "Good Internet";
        };
        wifi-security = {
	  auth-alg = "open";
          key-mgmt = "wpa-psk";
	  psk = "$GOOD_INTERNET_PSK";
        };
      };
    };
  };
}
