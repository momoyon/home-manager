{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "momoyon";
  home.homeDirectory = "/home/momoyon";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Let home manager manage Graphical Services
  xsession.enable = true;
  xsession.windowManager.command = "...";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
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
  #  /etc/profiles/per-user/momoyon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "momoyon";
    userEmail = "momoyon@momoyon.org";
    lfs.enable = true;
    diff-so-fancy.enable = true;

    aliases = {
      lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      lg = "lg1";
    };

    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
	compression = 0;
      };
      http.version = "HTTP/2";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      edit = "sudo -e";
      nixos-config = "sudo $EDITOR /etc/nixos/configuration.nix";
      nixos-update = "sudo nixos-rebuild switch";
      hm-config    = "$EDITOR $HOME/.config/home-manager/home.nix";
      hm-update    = "home-manager switch";
      ls="ls --color=auto";
      dir="dir --color=auto";
      vdir="vdir --color=auto";
  
      grep="grep --color=auto";
      fgrep="fgrep --color=auto";
      egrep="egrep --color=auto";
  
      ip="ip -color=auto";
      ll="ls -hl";
      la="ls -Ah";
      l="ls -CF";
      mkdir="mkdir -pv";
      yt-dlp="yt-dlp --add-metadata -ic";
      yt-dlpa="yt-dlp --add-metadata -xic";
      cclip="xclip -selection clipboard";
      mv="mv -vi";
      cp="cp -vi";
      rm="rm -vIdi";
      gits="git status";
      gitb="git branch";
      gitc="git commit";
      gita="git add";
      gitr="git remote";
      gitp="git push";
      gitd="git diff";
      gitl="git log --all --decorate --oneline --graph";
      lgit="lazygit";
      wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts";
      v="nvim";
      fetch="fastfetch";
      df="df -x tmpfs";
      
      # sudo
      s="sudo systemctl";

    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "pkill *" "cp *"];
  };


  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fantasque-sans-mono;
      name = "Fantasque Sans Mono";
      size = 12.0;
    };
    
    keybindings = let kitty_mod = "alt"; in {
      "${kitty_mod}+c"       = "copy_to_clipboard";
      "${kitty_mod}+v"       = "paste_from_clipboard";
      "${kitty_mod}+k"       = "scroll_line_up";
      "${kitty_mod}+j"       = "scroll_line_down";
      "${kitty_mod}+u"       = "scroll_page_up";
      "${kitty_mod}+d"       = "scroll_page_down";
      "${kitty_mod}+g"       = "scroll_home";
      "${kitty_mod}+shift+g" = "scroll_end";
      "ctrl+${kitty_mod}+u" = "kitten unicode_input";
    };

    themeFile = "Catppuccin-Mocha";
  };
}
