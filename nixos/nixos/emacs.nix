{
  pkgs,
  inputs,
  ...
}: let
  my-emacs = with pkgs;
    (emacsPackagesFor emacs-pgtk).emacs.pkgs.withPackages (epkgs:
      with epkgs; [
        vterm
        pdf-tools
        org-alert
        jinx
        treesit-grammars.with-all-grammars
      ]);
in {
  environment.systemPackages = with pkgs; [
    nixd

    my-emacs
    python312
    hunspell
    hunspellDicts.en_GB-ise
  ];

  nixpkgs.overlays = [(import inputs.emacs-overlay)];
}
