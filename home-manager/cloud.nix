{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # other
    sops

    # ci/cd
    tektoncd-cli

    # cloud
    awscli2
    buildpack
    doctl
    fluxcd
    google-cloud-sdk
    istioctl
    kn
    kopia
    krew
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    stern
    talosctl
    telepresence2
  ];
}
