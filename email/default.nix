{config, pkgs, theme, ...}:
{
  # email
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
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

  # Define the systemd service
  systemd.user.services.notmuch-index = {
    Unit = {
      Description = "Run notmuch index";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.notmuch}/bin/notmuch new"; # Command to run
      Restart = "on-failure"; # Optional: restart on failure
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  # Define the systemd timer to run the service every 5 minutes
  systemd.user.timers.notmuch-index = {
    Unit = {
      Description = "Run notmuch index every 5 minutes";
    };
    Timer = {
      Unit = "notmuch-index.service";
      OnCalendar = "*:0/5"; # Every 5 minutes
      Persistent = true; # Ensures it runs if missed (e.g., after suspend)
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
