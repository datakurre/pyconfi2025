{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.package.vscodium;
  unstable = import inputs.unstable {
    system = pkgs.system;
    config = {
      allowUnfree = true;
    };
  };
  vscode-marketplace =
    (inputs.nix-vscode-extensions.extensions.${pkgs.system}.forVSCodeVersion "1.99.1")
    .vscode-marketplace;
  vscode-marketplace-release =
    (inputs.nix-vscode-extensions.extensions.${pkgs.system}.forVSCodeVersion "1.99.1")
    .vscode-marketplace-release;
  inherit (lib)
    types
    mkOption
    mkIf
    optionals
    ;
in
{
  options.package.vscodium = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    unfree = mkOption {
      type = types.bool;
      default = false;
    };
    vim = mkOption {
      type = types.bool;
      default = false;
    };
    copilot = mkOption {
      type = types.bool;
      default = false;
    };
    continue = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config.packages = mkIf cfg.enable [
    (unstable.vscode-with-extensions.override {
      vscode = if cfg.unfree then unstable.vscode else unstable.vscodium;
      vscodeExtensions =
        [
          unstable.vscode-extensions.ms-vscode.makefile-tools
          vscode-marketplace.bbenoist.nix
          vscode-marketplace.tamasfe.even-better-toml
          vscode-marketplace.mathematic.vscode-latex
        ]
        ++ optionals cfg.vim [
          vscode-marketplace.vscodevim.vim
        ]
        ++ optionals cfg.copilot [
          (vscode-marketplace-release.github.copilot.override { meta.licenses = [ ]; })
          (vscode-marketplace-release.github.copilot-chat.override { meta.licenses = [ ]; })
        ]
        ++ optionals cfg.continue [
          vscode-marketplace.continue.continue
        ];
    })
  ];
}
