{ pkgs, ... }: {
  home.packages = with pkgs; [
    # general
    shared-mime-info

    # utility
    fd
    go-task
    jq
    overmind
    ripgrep
    shellcheck
    yq-go

    # dev
    mise
    pgcli
    rustup
    valkey # for redis-cli
  ];
}
