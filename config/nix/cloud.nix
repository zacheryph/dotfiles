{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # other
    sops

    # ci/cd
    tektoncd-cli

    # cloud
    buildpack
    doctl
    fluxcd
    google-cloud-sdk
    istioctl
    kopia
    krew
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    stern
    talosctl
    telepresence2
    terraform
  ];
}
