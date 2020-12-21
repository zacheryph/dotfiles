{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;

    envExtra = ''
      export BAT_THEME=Nord
      export CASE_SENSITIVE="true"
      export COMPLETION_WAITING_DOTS="true"
      export DISABLE_UNTRACKED_FILES_DIRTY="true"
      export EDITOR=vim
      export GPG_TTY=$(tty)
      export HIST_STAMPS="yyyy-mm-dd"
      export LANG=en_US.UTF-8
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
    '';

    shellAliases = {
      # misc
      batl = "bat -l yaml";
      batn = "bat -l json";
      pwgen = "ruby -r securerandom -e 'puts SecureRandom.urlsafe_base64(rand(24..40))'";

      # docker helpers
      up = "docker-compose up -d";
      dockervm = "docker run --rm -it --privileged --pid=host walkerlee/nsenter -t 1 -m -u -i -n bash";

      # kubernetes
      k = "kubectl";
      kap = "k apply -f";
      kctx = "k config use-context";
      kd = "k describe";
      ke = "k explain";
      ker = "k explain --recursive";
      kg = "k get";
      kga = "kg --all-namespaces";
      kns = "k config set-context --current --namespace";
      kr = "k run";
      ktc = "k create --dry-run=client --output=yaml";
      ktr = "k run --dry-run --output=yaml";
      kts = "k expose --dry-run --output=yaml";
      kseal = "kubeseal --format=yaml";
    };

    initExtra = ''
      function drun() {
        docker run --rm -it --user $(id -u):$(id -g) -v $PWD:/data --workdir /data "$@"
      }

      source <(kubectl completion zsh)
    '';

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
      {
        name = "gitster-theme";
        file = "gitster.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "malnick";
          repo = "zsh-gitster-theme";
          rev = "d670b53a11977ea07583ab5b21bd0a84ccb909d4";
          sha256 = "0c49zkqhjz0a3xn5s1jn4c5qkxs7givs6ddjlyn8ijf8h2qcd3ig";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "colored-man-pages"
        "docker"
        "doctl"
        "helm"
        "osx"
        "systemadmin"
        # "gcloud" # error looking for homebrews /usr/local/Caskroom
        "git-extras"
        "gpg-agent"
      ];
    };
  };
}
