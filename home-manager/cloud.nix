{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # backups
    kopia

    # encryption / secrets
    git-crypt
    keybase
    libargon2
    sops

    # providers
    awscli2
    doctl
    google-cloud-sdk

    # kubernetes
    fluxcd
    krew
    kluctl
    kubectl
    kubeswitch
    kubernetes-helm
    kustomize
    lens

    # tofu (use mise for opentofu versioning)
    tofu-ls
  ];

  # we want "kubectx"
  programs.zsh.shellAliases = {
    kubectx = "switcher";
  };
}
