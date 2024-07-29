{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # backups
    kopia


    # encryption / secrets
    age
    sops

    # providers
    awscli2
    doctl
    google-cloud-sdk

    # kubernetes
    fluxcd
    istioctl
    kn
    krew
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    talosctl
    telepresence2

    # # cloud
    # buildpack
    # stern
  ];
}
