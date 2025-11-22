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
  programs.zsh = {
    initContent = ''
      source <(switcher init zsh)
      source <(switch completion zsh)
    '';

    shellAliases = {
      kubectx = "switch";
      helm-search = "helm search repo";
    };

    siteFunctions = {
      helm-chart = ''helm show chart $@ | bat --language yaml'';
      helm-values = ''helm show values $@ | bat --language yaml'';
    };
  };
}
