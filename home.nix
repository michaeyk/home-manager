{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mike";
  home.homeDirectory = "/home/mike";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Adds the 'hello' command to your environment. It prints a friendly
    # "Hello, world!" when run.
    # pkgs.hello

    # archive
    zip
    unzip

    # backup
    rsync
    restic

    # email
    aerc
    notmuch
    oama

    # encryption
    gnupg
    pass

    # fonts
    nerdfonts

    # files and directories
    yazi
    fzf
    fd
    zoxide

    # hyprland
    hyprlock
    hypridle
    fuzzel
    bemoji
    grim
    slurp
    swappy

    # media
    mpv
    vlc
    spotify
    nsxiv

    # messaging
    gajim

    # pdf
    poppler

    # productivity
    obsidian

    # utils
    ripgrep
    jq
    eza
    bat
    btop

    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?
    # (pkgs.nerdfonts.override {fonts = ["FantasqueSansMono"];})

    # You can also create simple shell scripts directly inside your
    # configuration. For example, this adds a command 'my-hello' to your
    # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "obsidian"
      "spotify"
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mike/etc/profile.d/hm-session-vars.sh
  programs.git = {
    enable = true;
    userName = "Michael Kim";
    userEmail = "mike@michaelkim.net";

    extraConfig = {
      core = {
        editor = "${pkgs.helix}/bin/hx";
      };
    };
  };

  accounts.email = {
    maildirBasePath = ".maildir";
    accounts = {
      "personal" = {
        address = "mike@michaelkim.net";
        userName = "mike@michaelkim.net";
        realName = "Michael Kim";
        signature = {
          text = ''
            Michael Kim
          '';
          showSignature = "append";
        };
        passwordCommand = "${pkgs.pass}/bin/pass show email/mike@michaelkim.net | head -n1";
        imap.host = "imap.fastmail.com";
        smtp.host = "smtp.fastmail.com";
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          patterns = ["*"];
          extraConfig = {
            channel = {
              Sync = "All";
            };
            account = {
              Timeout = 120;
              PipelineDepth = 1;
            };
          };
        };
        msmtp.enable = true;
        notmuch.enable = true;
        primary = true;
      };

      "tsbot" = {
      };
    };
  };
  # programs.msmtp.extraConfig =
  # ''
  #   # Set default values for all following accounts.
  #   defaults
  #   auth           on
  #   tls            on
  #   tls_trust_file /etc/ssl/certs/ca-certificates.crt
  #   logfile        ~/.msmtp.log

  #   # A freemail service
  #   account        fastmail
  #   host           smtp.fastmail.com
  #   port           465
  #   from           mike@michaelkim.net
  #   user           mike@michaelkim.net
  #   passwordeval "pass show email/mike@michaelkim.net | head -n1"
  #   tls_starttls   off

  #   account default : fastmail
  # '';

  programs.zathura.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
