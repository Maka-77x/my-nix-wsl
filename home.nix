{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  secrets,
  pkgs,
  username,
  nix-index-database,
  ...
}:
let
  unstable-packages = with pkgs.unstable; [
    # Core System Utilities - Should be system packages
    coreutils # GNU core utilities for basic file, shell and text manipulation
    dnsutils # DNS utilities like dig, nslookup
    findutils # Basic file searching utilities
    inetutils # Network utilities
    moreutils # Additional Unix utilities
    pciutils # PCI utilities (requires system)
    usbutils # USB utilities (requires system)
    lshw # Hardware lister (requires system)
    killall # Process termination utility (requires system)
    cacert # Certificate authorities (system)
    openssl # SSL/TLS toolkit (system)

    # Shell Environments
    any-nix-shell # Fish/ZSH support for nix shell
    bashInteractive # Bash shell
    nushell # Modern shell alternative

    # Terminal Multiplexers and Session Management
    screen # Terminal multiplexer
    tmux # Terminal multiplexer
    zellij # Terminal workspace

    # Terminal Enhancement Tools
    bat # Better cat replacement
    bottom # System/Process monitor
    eza # Modern ls replacement
    fzf # Fuzzy finder
    htop # Process viewer
    less # Pager
    tree # Directory structure viewer

    # Version Control
    git # Version control system
    git-crypt # Transparent file encryption in git

    # Text Editors
    lunarvim # Neovim configuration
    neovim # Text editor
    vim # Text editor

    # Development Environment
    pre-commit # Git hook manager
    volta # JavaScript tool manager
    github-desktop # Git GUI

    # Build and Development Tools
    alejandra # Nix formatter
    shfmt # Shell script formatter
    dura # Background build system

    # JSON/YAML/TOML Processing
    jq # JSON processor
    jc # JSON converter
    jo # JSON output
    gron # Make JSON greppable
    yj # YAML/TOML/JSON converter
    yq # YAML processor

    # Text Processing
    ripgrep # Fast grep replacement
    sd # Find & replace
    pandoc # Universal document converter

    # Kubernetes Tools
    kubectl # Kubernetes CLI
    k9s # Kubernetes UI
    helm # Kubernetes package manager
    k3d # Local Kubernetes clusters
    kubefirst # Kubernetes platform

    # Cloud Provider Tools
    aws-vault # AWS security tool
    azure-cli # Azure CLI
    google-cloud-sdk.withExtraComponents
    [ google-cloud-sdk.components.gke-gcloud-auth-plugin ]

    # Container Tools
    docker-credential-helpers # Docker credential manager

    # Infrastructure as Code
    terraform # Infrastructure as code
    pulumi # Infrastructure as code

    gnupg # Encryption suite
    mkpasswd # Password generator
    openssh # SSH client/server (system)
    mkcert # Local SSL certificates
    sops # Secret management
    jq
    jc
    jo
    gron
    yj
    yq
    pup # # json/toml/yaml/hcl/xml/html handling

    fd
    fx
    git
    git-crypt
    mosh
    lix
    any-nix-shell
    bashInteractive
    bat
    bc
    bottom
    curl
    dig
    eza
    feh
    fd
    fx
    git
    htop
    # killall
    # nix-output-monitor
    less
    lshw
    lunarvim
    mosh
    neovim
    nix-prefetch-github
    nixos-generators
    nushell
    nurl
    ripgrep
    sd
    sops
    tmux
    tree
    vim
    wget
    zellij
    zip

    charm
    gum
    screen

    cacert
    git-crypt
    gnupg
    mkpasswd
    openssh
    openssl
    ## === Monitoring ===
    dua # <- learn about the disk usage of directories, fast!
    lnav # <- log file navigator
    procs # <- a "modern" replacement for ps
    ## === Files ===
    du-dust # <- like du but more intuitive
    file # <- a program that shows the type of files
    unzip # <- *.zip archive extraction utility

    # awscli2 # Unified tool to manage your AWS services
    rsync # A fast incremental file transfer utility
    xh # Friendly and fast tool for sending HTTP requests
    ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep
    croc # Easily and securely send things from one computer to another
    fzf # A command-line fuzzy finder written in Go
    cloud-nuke # A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it
    chamber # A tool for managing secrets by storing them in AWS SSM Parameter Store
    shfmt # A shell parser and formatter
    openshift
    pandoc
    kubernetes-helm
    helmfile
    wsl-open
    kubectl
    aws-vault
    arkade
    fluxcd
    k9s
    topgrade
    kompose
    scaleway-cli
    spr
    pulumi
    azure-cli
    krew
    civo
    operator-sdk
    kwalletmanager
    eksctl
    yq
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    terraform
    crc
    kubie
    docker-credential-helpers
    dapr-cli
    fd
    alejandra
    pre-commit
    github-desktop
    fh
    dura
    mkcert
    ffmpeg
    volta
    jetbrains.pycharm-community
    grim
    slurp
    swappy
    wlsunset
    python-launcher
    github-copilot-cli
    k3d
    kubefirst
  ];

  stable-packages = with pkgs; [
    # FIXME: customize these stable packages to your liking for the languages that you use

    # FIXME: you can add plugins, change keymaps etc using (jeezyvim.nixvimExtend {})
    # https://github.com/LGUG2Z/JeezyVim#extending
    jeezyvim

    # key tools
    gh # for bootstrapping
    just

    # core languages
    rustup
    go
    lua
    nodejs
    python3
    typescript

    # rust stuff
    cargo-cache
    cargo-expand

    # local dev stuf
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    ccls # c / c++
    gopls
    nil # nix
    nixd
    nixfmt-rfc-style
    sumneko-lua-language-server

    # formatters and linters
    alejandra # nix
    black # python
    deadnix # nix
    golangci-lint
    lua52Packages.luacheck
    nodePackages.prettier
    ruff # python
    shellcheck
    shfmt
    statix # nix
    sqlfluff
    tflint
  ];
in
{
  imports = [ nix-index-database.hmModules.nix-index ];

  home.stateVersion = "24.05";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    sessionVariables.EDITOR = "nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";
  };

  home.packages = stable-packages ++ unstable-packages;
  # ++
  #   # FIXME: you can add anything else that doesn't fit into the above two lists in here
  #   [
  #     # pkgs.some-package
  #     # pkgs.unstable.some-other-package
  #   ]

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    # FIXME: disable this if you don't want to use the starship prompt
    starship.enable = true;
    starship.settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = false;
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      python.disabled = true;
      ruby.disabled = true;
      hostname.ssh_only = false;
      hostname.style = "bold green";
    };

    # FIXME: disable whatever you don't want
    fzf.enable = true;
    fzf.enableFishIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;
    zoxide.options = [ "--cmd cd" ];
    broot.enable = true;
    broot.enableFishIntegration = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "mmparrett90+study@gmail.com"; # FIXME: set your git email
      userName = "Maka-77x"; # FIXME: set your git username
      extraConfig = {
        # FIXME: uncomment the next lines if you want to be able to clone private https repos
        url = {
          "https://oauth2:${secrets.github_token}@github.com" = {
            insteadOf = "https://github.com";
          };
        };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    # FIXME: This is my fish config - you can fiddle with it if you want
    fish = {
      enable = true;
      # FIXME: run 'scoop install win32yank' on Windows, then add this line with your Windows username to the bottom of interactiveShellInit
      interactiveShellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        ${pkgs.lib.strings.fileContents (
          pkgs.fetchFromGitHub {
            owner = "rebelot";
            repo = "kanagawa.nvim";
            rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
            sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
          }
          + "/extras/kanagawa.fish"
        )}

        set -U fish_greeting
        if not set -q SSH_AUTH_SOCK
          eval (ssh-agent -c)
          set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
          set -Ux SSH_AGENT_PID $SSH_AGENT_PID
        end
        fish_add_path --append /mnt/c/Users/mparrett/scoop/apps/win32yank/current
        fish_add_path --append /mnt/c/Users/mparrett/scoop/apps/vscode/current

      '';
      functions = {
        refresh = "source $HOME/.config/fish/config.fish";
        take = ''mkdir -p -- "$1" && cd -- "$1"'';
        ttake = "cd $(mktemp -d)";
        show_path = "echo $PATH | tr ' ' '\n'";
        posix-source = ''
          for i in (cat $argv)
            set arr (echo $i |tr = \n)
            set -gx $arr[1] $arr[2]
          end
        '';
      };
      shellAbbrs =
        {
          gc = "nix-collect-garbage --delete-old";
        }
        # navigation shortcuts
        // {
          ".." = "cd ..";
          "..." = "cd ../../";
          "...." = "cd ../../../";
          "....." = "cd ../../../../";
        }
        # git shortcuts
        // {
          gapa = "git add --patch";
          grpa = "git reset --patch";
          gst = "git status";
          gdh = "git diff HEAD";
          gp = "git push";
          gph = "git push -u origin HEAD";
          gco = "git checkout";
          gcob = "git checkout -b";
          gcm = "git checkout master";
          gcd = "git checkout develop";
          gsp = "git stash push -m";
          gsa = "git stash apply stash^{/";
          gsl = "git stash list";
        };
      shellAliases = {
        docker = "/run/current-system/sw/bin/docker";
        jvim = "nvim";
        lvim = "nvim";
        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";

        codewsl = "/mnt/c/Users/mparrett/scoop/apps/vscode/current/Code.exe";
        code = "codewsl --remote=wsl+wslnix01";
      };
      plugins = [
        {
          inherit (pkgs.fishPlugins.autopair) src;
          name = "autopair";
        }
        {
          inherit (pkgs.fishPlugins.done) src;
          name = "done";
        }
        {
          inherit (pkgs.fishPlugins.sponge) src;
          name = "sponge";
        }
      ];
    };
  };
}
