{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # other
    sops

    # ci/cd
    tektoncd-cli

    # cloud
    doctl
    fluxcd
    google-cloud-sdk
    istioctl
    krew
    kubectl
    kubectx
    kubernetes-helm
    kubeval
    kustomize
    stern
    telepresence2
    terraform
  ];
}
