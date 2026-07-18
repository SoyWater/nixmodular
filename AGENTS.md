# Desktop wrapper migration

The `niri-desktop` to `desktop` migration is intentionally scoped to:

- `flake.nix` and root flake wiring;
- `wrapped-applications/`; and
- this guidance file.

The active `legion` desktop cutover additionally permits:

- `modules/features/desktop.nix`; and
- `modules/hosts/legion/configuration.nix`.

Do not edit any other path under `modules/` for this migration.
