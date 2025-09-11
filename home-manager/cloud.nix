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
    kubectx
    kubernetes-helm
    kustomize
    lens

    # # cloud
    # buildpack
    # stern
  ];
}
