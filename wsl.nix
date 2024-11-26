{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  secrets,
  username,
  hostname,
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  # FIXME: change to your tz! look it up with "timedatectl list-timezones"
  time.timeZone = "Europe/London";

  networking.hostName = "${hostname}";
  firewall.enable = true;
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPortRanges = [
    # KDE connect
    {
      from = 1714;
      to = 1764;
    }
    # Chromecast
    # {
    #   from = 32768;
    #   to = 61000;
    # }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE connect
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedTCPPorts = [
    80
    443
    8000 # http server
    24800 # synergy
    22000 # Syncthing
    51413 # transmission
    # 45678 # arduino OTA
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # Chromecast discovery
    21027 # Syncthing discovery
    # 45678 # arduino OTA
  ];

  # FIXME: change your shell here if you don't want fish
  programs.fish.enable = true;
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
  environment.pathsToLink = [ "/share/fish" ];
  environment.shells = [ pkgs.fish ];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  # FIXME: uncomment the next line to enable SSH
  services = {
    openssh = {
      enable = true;
      ports = [ 43225 ];
      passwordAuthentication = false;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    # FIXME: add your own hashed password
    hashedPassword = "$y$j9T$LHyNHy6CvSPoZjyoi.XMd1$ivMq1JpKwO.tTCsec9zbSmEP4GeNEGwYAQcX8.Vr2z3";
    # FIXME: add your own ssh public key
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHGLwKOIAbkKMBVRtkkQ7zs3xhV7CitL50ceFPF7w93gyNWe4mM3NuDzJj/xitCYKRpUHzhArnskzFNjDj+ZNsXH8Ry/wQJMX1+u1xlwiSoJKZ6jSw+XkS2SswjuvABl30DdeHlG5xsnptSAlhkcQo985O0X+ewAtz2dNjUyOw2UPVFFpXfUaOCc5HWCQxDjwjeI+5KYvt3EiavdgXby2PoiDp3gkSeoVRn5ZEC7CyUgwq0FSllVrMGhr6uNzJEkTnj1DTtk8rjHrg6xTFQspY0Olu4TZXtf5aJ5uPWXrYkpAm3HJzWGf4lXpIeW+IswpS15fdZssTyWmqt+OM8Bjx+g+ZN94nJCAiGCtcWlAnC3HMxrClDyWxbbCb9bJdEEnHIs8cLt6+Wk7Bi2SrwK+IaHQTDVgExiIjL+kiJng/NA20/iz4BO9xkzhF6ADPlxVBt2SRDrDjbzsnDfPxC2oqpcHEN2icjcePj7KcjjoydthG4/PJ+0/y9MPiNSrvByT6+Whd74fYYYIEE8cFPFduHOYz7TujHWdcRIRirnw2YmLtsKIoUKzjOBtZ3Eae9NnZDbtsc3/4+fDRT5VGKqmQCHwjJ94jvZR2+jGgC0pPCEdv1hc76w+mNduD1UTKedjd+QVHP2ewWxAsDYHPV+ySS+ITPZE1lxkx7w5v4B0Slw== mimiparretto@Deliveroo-Latit5430"
      ##
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSw9DzqEUmIvj3lmSKsCLKdmunIZBxXDLKovL0A47u+ mimiparretto@Deliveroo-Latit5430"
      ##
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiBdNS4Z8S8aB2Z+Oh2mQFl7pyQ0MG0Fah02H2er4uU mmparrett90+study@gmail.com"
    ];
  };

  home-manager.users.${username} = {
    imports = [ ./home.nix ];
  };

  system.stateVersion = "24.05";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;

    extraBin = with pkgs; [
      # Binaries for Docker Desktop wsl-distro-proxy
      { src = "${coreutils}/bin/mkdir"; }
      { src = "${coreutils}/bin/cat"; }
      { src = "${coreutils}/bin/whoami"; }
      { src = "${coreutils}/bin/ls"; }
      { src = "${coreutils}/bin/uname"; }
      { src = "${busybox}/bin/addgroup"; }
      { src = "${su}/bin/groupadd"; }
      { src = "${su}/bin/usermod"; }
    ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  ## patch the script 
  systemd.services.docker-desktop-proxy.script = lib.mkForce ''${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"'';

  # FIXME: uncomment the next block to make vscode running in Windows "just work" with NixOS on WSL
  # solution adapted from: https://github.com/K900/vscode-remote-workaround
  # more information: https://github.com/nix-community/NixOS-WSL/issues/238 and https://github.com/nix-community/NixOS-WSL/issues/294
  systemd.user = {
    paths.vscode-remote-workaround = {
      wantedBy = [ "default.target" ];
      pathConfig.PathChanged = "%h/.vscode-server/bin";
    };
    services.vscode-remote-workaround.script = ''
      for i in ~/.vscode-server/bin/*; do
        if [ -e $i/node ]; then
          echo "Fixing vscode-server in $i..."
          ln -sf ${pkgs.nodejs_18}/bin/node $i/node
        fi
      done
    '';
  };

  nix = {
    settings = {
      trusted-users = [ username ];
      # FIXME: use your access tokens from secrets.json here to be able to clone private repos on GitHub and GitLab
      access-tokens = [
        "github.com=${secrets.github_token}"
        #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
      show-trace = true;
      accept-flake-config = true;
      auto-optimise-store = true;
      allow-import-from-derivation = false;
    };
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/mimiparretto/channels"
    ];

    package = lib.mkDefault pkgs.lix;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
