# Desktop wrapper migration

The `niri-desktop` to `desktop` migration is intentionally scoped to:

- `flake.nix` and root flake wiring;
- `wrapped-applications/`; and
- this guidance file.

Do not edit anything under `modules/` for this migration. NixOS, Home Manager,
greeter, and active host wiring are deferred to later slices.
