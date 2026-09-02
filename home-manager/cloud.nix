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
    helmfile
    fluxcd
    kcl
    krew
    kubectl
    kubeswitch
    kubernetes-helm
    kustomize

    # tofu (use mise for opentofu versioning)
    tofu-ls
  ];

  # tofu CLI config: share a plugin cache across working directories
  home.file.".tofurc".source = ./files/tofurc;

  # tofu won't create the cache dir itself
  home.file.".terraform.d/plugin-cache/.keep".text = "";

  # we want "kubectx"
  programs.zsh = {
    initContent = ''
      source <(switcher init zsh)
      source <(switch completion zsh)
    '';

    shellAliases = {
      ksel = "switch";
      kubectx = "switch";
      helm-search = "helm search repo";
    };

    siteFunctions = {
      helm-chart = ''helm show chart $@ | bat --language yaml'';
      helm-values = ''helm show values $@ | bat --language yaml'';
    };
  };
}
