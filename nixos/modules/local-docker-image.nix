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
          type = types.nullOr types.str;
          default = null;
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

        dockerfileText = mkOption {
          type = types.nullOr types.lines;
          default = null;
          description = "Optional inline Dockerfile content. If repo is set, the repository is used as build context.";
        };

        baseImage = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional base image whose digest is included in rebuild detection.";
        };

        image = mkOption {
          type = types.str;
          description = "Local image tag to build and import.";
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

        postBuildCommands = mkOption {
          type = types.lines;
          default = "";
          description = "Shell commands to run after the image is built and imported.";
        };

        restartKube = mkOption {
          type = types.listOf (
            types.submodule {
              options = {
                namespace = mkOption {
                  type = types.str;
                  default = "default";
                  description = "Kubernetes namespace containing the resource to restart.";
                };

                resource = mkOption {
                  type = types.str;
                  description = "Kubernetes resource to restart, e.g. statefulset/hermes.";
                };
              };
            }
          );
          default = [ ];
          description = "Kubernetes resources to restart after build/import.";
        };
      };
    };

  mkServiceName = name: "local-docker-image-${name}";
  mkStateDir = name: "/var/lib/local-docker-images/${name}";

  mkImageService =
    name: image:
    let
      serviceName = mkServiceName name;
      stateDir = mkStateDir name;
      imageTar = "${stateDir}/image.tar";
      inlineDockerfile =
        if image.dockerfileText != null then
          pkgs.writeText "local-docker-image-${name}.Dockerfile" image.dockerfileText
        else
          null;
      dockerfileArg =
        if image.dockerfileText != null then
          "-f \"$inline_dockerfile\""
        else
          lib.optionalString (image.dockerfile != null) "-f \"$build_context/${image.dockerfile}\"";
      usesK3s = image.importToK3s || image.restartKube != [ ];
      k3sCtr = "${config.services.k3s.package}/bin/k3s ctr -n k8s.io images";
      kubectl = "${config.services.k3s.package}/bin/k3s kubectl";
      restartKubeCommands = lib.concatMapStringsSep "\n" (
        restart:
        "${kubectl} -n ${lib.escapeShellArg restart.namespace} rollout restart ${lib.escapeShellArg restart.resource}"
      ) image.restartKube;
      after = [
        "network-online.target"
      ]
      ++ lib.optional usesK3s "k3s.service"
      ++ image.after;
      requires = lib.optional usesK3s "k3s.service" ++ image.requires;
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
        skopeo
      ];

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = stateDir;
      };

      script = ''
        set -euo pipefail

        state=${lib.escapeShellArg stateDir}
        src="$state/src"
        build_context="$state/context"
        inline_dockerfile="$state/Dockerfile"
        built_revision_file="$state/built-revision"
        image=${lib.escapeShellArg image.image}
        image_tar=${lib.escapeShellArg imageTar}
        branch=${lib.escapeShellArg image.branch}

        mkdir -p "$state"

        revision=""
        ${lib.optionalString (image.repo != null) ''
          if [ ! -d "$src/.git" ]; then
            rm -rf "$src"
            git clone --depth=1 --branch "$branch" ${lib.escapeShellArg image.repo} "$src"
          else
            git -C "$src" fetch --depth=1 origin "$branch"
            git -C "$src" checkout --force "origin/$branch"
          fi

          build_context="$src/${image.context}"
          revision="$(git -C "$src" rev-parse HEAD)"
        ''}
        ${lib.optionalString (image.repo == null) ''
          rm -rf "$build_context"
          mkdir -p "$build_context"
        ''}
        ${lib.optionalString (image.dockerfileText != null) ''
          cp ${inlineDockerfile} "$inline_dockerfile"
          dockerfile_revision="$(sha256sum "$inline_dockerfile" | cut -d " " -f 1)"
          revision="$revision:$dockerfile_revision"
        ''}
        ${lib.optionalString (image.baseImage != null) ''
          base_digest="$(skopeo inspect --format '{{.Digest}}' docker://${lib.escapeShellArg image.baseImage})"
          revision="$revision:$base_digest"
        ''}

        ${imagePresentCheck}

        if [ -f "$built_revision_file" ] \
          && [ "$(cat "$built_revision_file")" = "$revision" ] \
          && [ "$image_present" = 1 ]; then
          echo "Local Docker image $image is current at $revision"
          exit 0
        fi

        podman build --pull=always -t "$image" ${dockerfileArg} "$build_context"
        ${lib.optionalString image.importToK3s ''
          podman save "$image" -o "$image_tar"
          ${k3sCtr} import "$image_tar"
          rm -f "$image_tar"
        ''}
        ${image.postBuildCommands}
        ${restartKubeCommands}
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
    assertions = lib.flatten (
      lib.mapAttrsToList (name: image: [
        {
          assertion = image.repo != null || image.dockerfileText != null;
          message = "my.localDockerImages.images.${name} needs repo or dockerfileText.";
        }
        {
          assertion = !(image.dockerfile != null && image.dockerfileText != null);
          message = "my.localDockerImages.images.${name} cannot set both dockerfile and dockerfileText.";
        }
      ]) cfg.images
    );

    systemd.tmpfiles.rules = lib.mapAttrsToList (
      name: _: "d ${mkStateDir name} 0755 root root - -"
    ) cfg.images;

    systemd.services = lib.mapAttrs' (
      name: image: lib.nameValuePair (mkServiceName name) (mkImageService name image)
    ) cfg.images;

    systemd.timers = lib.mapAttrs' (
      name: image: lib.nameValuePair (mkServiceName name) (mkImageTimer name image)
    ) cfg.images;
  };
}
