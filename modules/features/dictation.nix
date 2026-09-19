{ moduleWithSystem, ... }:
{
  flake.nixosModules.dictation = moduleWithSystem (
    { pkgs, ... }:
    let
      ollama = pkgs.ollama-vulkan;
      voxtype = pkgs.voxtype.override {
        onnxSupport = true;
        vulkanSupport = true;
      };

      cleanupCommand = pkgs.writeShellApplication {
        name = "dictation-cleanup";
        runtimeInputs = [ ollama pkgs.curl pkgs.jq ];
        text = ''
          dictated_text=$(jq -Rs .)
          prompt=$(jq -n --argjson dictated_text "$dictated_text" '
            "Clean up the dictated text below. Remove filler words and false starts; fix grammar and punctuation. Preserve meaning, technical terms, proper nouns, commands, code, URLs, file paths, and quoted text exactly. Do not add information, summarize, explain, or answer the text. Output only the cleaned text.\n\nDICTATED TEXT:\n" + $dictated_text
          ')

          curl --fail --silent --show-error \
            --max-time 25 \
            http://127.0.0.1:11434/api/generate \
            --header 'Content-Type: application/json' \
            --data "$(jq -n --argjson prompt "$prompt" '{ model: "qwen3:4b-instruct", prompt: $prompt, stream: false }')" \
            | jq --raw-output '.response'
        '';
      };

      voxtypeConfig = (pkgs.formats.toml { }).generate "voxtype-config.toml" {
        state_file = "auto";
        engine = "parakeet";

        hotkey.enabled = false;

        audio = {
          device = "default";
          sample_rate = 16000;
          max_duration_secs = 90;
          feedback = {
            enabled = true;
            theme = "subtle";
            volume = 0.4;
          };
        };

        parakeet = {
          # Quantized TDT v3: the fastest current Parakeet model while
          # retaining punctuation and capitalization.
          model = "parakeet-tdt-0.6b-v3-int8";
          model_type = "tdt";
          on_demand_loading = false;
        };

        output = {
          mode = "type";
          driver_order = [ "wtype" "clipboard" ];
          fallback_to_clipboard = true;
          type_delay_ms = 0;
          wait_for_modifier_release = false;
          notification.on_transcription = true;
          post_process = {
            command = "${cleanupCommand}/bin/dictation-cleanup";
            timeout_ms = 30000;
            trim = true;
            fallback_on_empty = true;
          };
        };

        # Nixpkgs currently packages no Voxtype OSD frontend. Audio feedback
        # and completion notifications provide feedback without a failing OSD.
        osd.enabled = false;

        text = {
          spoken_punctuation = true;
          filter_filler_words = true;
          replacements = {
            "nix os" = "NixOS";
            "nix pkgs" = "nixpkgs";
            "vox type" = "Voxtype";
            "way land" = "Wayland";
          };
        };

        vad = {
          enabled = true;
          backend = "energy";
          threshold = 0.35;
          min_speech_duration_ms = 200;
        };
      };

      voxtypeControl = pkgs.writeShellApplication {
        name = "voxtype-control";
        runtimeInputs = [ voxtype ];
        text = ''
          exec voxtype --config ${voxtypeConfig} record "$@"
        '';
      };
    in
    {
      environment = {
        systemPackages = [ voxtype voxtypeControl cleanupCommand pkgs.wtype ];
        sessionVariables.LAUNCH_DICTATION = "${voxtypeControl}/bin/voxtype-control";
      };

      services.ollama = {
        enable = true;
        package = ollama;
        loadModels = [ "qwen3:4b-instruct" ];
      };

      systemd.user.services.voxtype = {
        description = "Voxtype dictation daemon";
        documentation = [ "https://voxtype.io" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        unitConfig.ConditionPathExists = "%h/.local/share/voxtype/models/parakeet-tdt-0.6b-v3-int8";
        unitConfig.X-Restart-Triggers = [ voxtypeConfig voxtype ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${voxtype}/bin/voxtype --config ${voxtypeConfig} daemon";
          Environment = [ "VOXTYPE_VULKAN_DEVICE=nvidia" ];
          Restart = "on-failure";
          RestartSec = 2;
        };
        wantedBy = [ "graphical-session.target" ];
      };
    }
  );
}
