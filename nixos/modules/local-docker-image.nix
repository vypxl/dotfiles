{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.localDockerImages;

  imageModule =
    { name, ... }:
    {
      options = with lib; {
        repo = mkOption {
          type = types.str;
          description = "Git repository URL containing the Docker build context.";
        };

        branch = mkOption {
          type = types.str;
          default = "main";
          description = "Git branch to track.";
        };

        context = mkOption {
          type = types.str;
          default = ".";
          description = "Path to the Docker build context inside the repository.";
        };

        dockerfile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional Dockerfile path relative to the build context.";
        };

        image = mkOption {
          type = types.str;
          description = "Local image tag to build and import.";
        };

        stateDir = mkOption {
          type = types.str;
          default = "/var/lib/local-docker-images/${name}";
          description = "State directory for the checkout and last-built revision.";
        };

        schedule = mkOption {
          type = types.str;
          default = "daily";
          description = "systemd OnCalendar expression for update checks.";
        };

        importToK3s = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to import the built image into k3s containerd.";
        };

        before = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Units that should start after this image builder.";
        };

        after = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Additional units that should start before this image builder.";
        };

        requires = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Additional required units.";
        };
      };
    };

  mkServiceName = name: "local-docker-image-${name}";

  mkImageService =
    name: image:
    let
      serviceName = mkServiceName name;
      imageTar = "${image.stateDir}/image.tar";
      dockerfileArg = lib.optionalString (
        image.dockerfile != null
      ) "-f \"$src/${image.context}/${image.dockerfile}\"";
      k3sCtr = "${config.services.k3s.package}/bin/k3s ctr -n k8s.io images";
      after = [
        "network-online.target"
      ]
      ++ lib.optional image.importToK3s "k3s.service"
      ++ image.after;
      requires = lib.optional image.importToK3s "k3s.service" ++ image.requires;
      imagePresentCheck =
        if image.importToK3s then
          ''
            if ${k3sCtr} ls | grep -q "$image"; then
              image_present=1
            else
              image_present=0
            fi
          ''
        else
          ''
            image_present=1
          '';
    in
    {
      description = "Build and import local Docker image ${name}";
      wantedBy = [ "multi-user.target" ];
      inherit after requires;
      before = image.before;
      wants = [ "network-online.target" ];

      path = with pkgs; [
        coreutils
        git
        gnugrep
        podman
      ];

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = image.stateDir;
      };

      script = ''
        set -euo pipefail

        state=${lib.escapeShellArg image.stateDir}
        src="$state/src"
        built_revision_file="$state/built-revision"
        image=${lib.escapeShellArg image.image}
        image_tar=${lib.escapeShellArg imageTar}
        branch=${lib.escapeShellArg image.branch}

        mkdir -p "$state"

        if [ ! -d "$src/.git" ]; then
          rm -rf "$src"
          git clone --depth=1 --branch "$branch" ${lib.escapeShellArg image.repo} "$src"
        else
          git -C "$src" fetch --depth=1 origin "$branch"
          git -C "$src" checkout --force "origin/$branch"
        fi

        revision="$(git -C "$src" rev-parse HEAD)"
        ${imagePresentCheck}

        if [ -f "$built_revision_file" ] \
          && [ "$(cat "$built_revision_file")" = "$revision" ] \
          && [ "$image_present" = 1 ]; then
          echo "Local Docker image $image is current at $revision"
          exit 0
        fi

        podman build --pull=always -t "$image" ${dockerfileArg} "$src/${image.context}"
        ${lib.optionalString image.importToK3s ''
          podman save "$image" -o "$image_tar"
          ${k3sCtr} import "$image_tar"
          rm -f "$image_tar"
        ''}
        printf '%s\n' "$revision" > "$built_revision_file"

        echo "Built $image from $revision"
      '';
    };

  mkImageTimer =
    name: image:
    let
      serviceName = mkServiceName name;
    in
    {
      description = "Update check for local Docker image ${name}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = image.schedule;
        Persistent = true;
        Unit = "${serviceName}.service";
      };
    };
in
{
  options.my.localDockerImages = with lib; {
    images = mkOption {
      type = types.attrsOf (types.submodule imageModule);
      default = { };
      description = "Local Docker images to build from Git and optionally import into k3s.";
    };
  };

  config = lib.mkIf (cfg.images != { }) {
    systemd.tmpfiles.rules = lib.mapAttrsToList (
      _: image: "d ${image.stateDir} 0755 root root - -"
    ) cfg.images;

    systemd.services = lib.mapAttrs' (
      name: image: lib.nameValuePair (mkServiceName name) (mkImageService name image)
    ) cfg.images;

    systemd.timers = lib.mapAttrs' (
      name: image: lib.nameValuePair (mkServiceName name) (mkImageTimer name image)
    ) cfg.images;
  };
}
