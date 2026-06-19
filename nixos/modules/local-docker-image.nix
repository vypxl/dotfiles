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

        repoTokenFile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional file containing a GitHub token for HTTPS repository clones.";
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

        baseImageTagPattern = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional regular expression for resolving the newest version tag for baseImage.";
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
    name: image: ensureOnly:
    let
      serviceName = if ensureOnly then "${mkServiceName name}-ensure" else mkServiceName name;
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
      restartKubeCommands = lib.concatMapStringsSep "\n" (restart: ''
        restart_namespace=${lib.escapeShellArg restart.namespace}
        restart_resource=${lib.escapeShellArg restart.resource}
        log "restart_resource=$restart_namespace/$restart_resource action=resolve_selector"
        selector="$(${kubectl} -n "$restart_namespace" get "$restart_resource" -o json | jq -r '.spec.selector.matchLabels // empty | to_entries | map("\(.key)=\(.value)") | join(",")')"
        if [ -z "$selector" ]; then
          echo "No pod selector found for $restart_namespace/$restart_resource" >&2
          log "restart_resource=$restart_namespace/$restart_resource selector=<missing> action=fail"
          exit 1
        fi
        log "restart_resource=$restart_namespace/$restart_resource selector=$selector action=delete_pods"
        ${kubectl} -n "$restart_namespace" delete pod -l "$selector" --ignore-not-found
      '') image.restartKube;
      after = [
        "network-online.target"
      ]
      ++ lib.optional usesK3s "k3s.service"
      ++ image.after;
      requires = lib.optional usesK3s "k3s.service" ++ image.requires;
      imagePresentCheck =
        if image.importToK3s then
          ''
            k3s_image_list_file="$state/k3s-images.txt"
            if ${k3sCtr} ls > "$k3s_image_list_file"; then
              log "k3s_image_list_status=ok file=$k3s_image_list_file"
            else
              log "k3s_image_list_status=failed"
              exit 1
            fi

            image_matches="$(grep -F "$image" "$k3s_image_list_file" || true)"
            if [ -n "$image_matches" ]; then
              while IFS= read -r image_match; do
                log "image_match=$image_match"
              done <<< "$image_matches"
              image_present=1
            else
              log "image_match=none"
              image_present=0
            fi
          ''
        else
          ''
            image_present=1
          '';
      gitAuthSetup = lib.optionalString (image.repoTokenFile != null) ''
        git_askpass="$state/git-askpass"
        {
          printf '%s\n' '#!/bin/sh'
          printf '%s\n' 'case "$1" in'
          printf '%s\n' '  *Username*) printf "%s\n" x-access-token ;;'
          printf '%s\n' '  *Password*) cat "$LOCAL_DOCKER_IMAGE_REPO_TOKEN_FILE" ;;'
          printf '%s\n' '  *) printf "\n" ;;'
          printf '%s\n' 'esac'
        } > "$git_askpass"
        chmod 0700 "$git_askpass"
        export GIT_ASKPASS="$git_askpass"
        export GIT_TERMINAL_PROMPT=0
        export LOCAL_DOCKER_IMAGE_REPO_TOKEN_FILE=${lib.escapeShellArg image.repoTokenFile}
      '';
    in
    {
      description = "Build and import local Docker image ${name}";
      wantedBy = lib.optional (!ensureOnly) "multi-user.target";
      inherit after requires;
      before = lib.optionals (!ensureOnly) image.before;
      wants = [ "network-online.target" ];

      path = with pkgs; [
        coreutils
        git
        gnugrep
        jq
        podman
        skopeo
      ];

      serviceConfig = {
        Type = "simple";
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
        image_name=${lib.escapeShellArg name}
        image_tar=${lib.escapeShellArg imageTar}
        branch=${lib.escapeShellArg image.branch}
        ensure_only=${if ensureOnly then "1" else "0"}
        build_args=()

        log() {
          printf '%s\n' "[local-docker-image:$image_name] $*"
        }

        log "start image=$image state=$state import_to_k3s=${lib.boolToString image.importToK3s} branch=$branch ensure_only=$ensure_only"
        log "config repo=${
          if image.repo == null then "<none>" else image.repo
        } context=${image.context} dockerfile=${
          if image.dockerfile == null then "<none>" else image.dockerfile
        } dockerfile_text=${lib.boolToString (image.dockerfileText != null)} base_image=${
          if image.baseImage == null then "<none>" else image.baseImage
        } base_image_tag_pattern=${
          if image.baseImageTagPattern == null then "<none>" else image.baseImageTagPattern
        }"

        mkdir -p "$state"
        ${gitAuthSetup}

        revision=""
        ${lib.optionalString (image.repo != null) ''
          if [ ! -d "$src/.git" ]; then
            log "repo_status=missing action=clone repo=${image.repo}"
            rm -rf "$src"
            git clone --depth=1 --branch "$branch" ${lib.escapeShellArg image.repo} "$src"
          else
            current_head="$(git -C "$src" rev-parse HEAD || true)"
            log "repo_status=present current_head=$current_head action=fetch_checkout repo=${image.repo}"
            git -C "$src" fetch --depth=1 origin "$branch"
            git -C "$src" checkout --force "origin/$branch"
          fi

          build_context="$src/${image.context}"
          revision="$(git -C "$src" rev-parse HEAD)"
          log "repo_revision=$revision build_context=$build_context"
        ''}
        ${lib.optionalString (image.repo == null) ''
          log "repo_status=none action=create_empty_context"
          rm -rf "$build_context"
          mkdir -p "$build_context"
        ''}
        ${lib.optionalString (image.dockerfileText != null) ''
          cp ${inlineDockerfile} "$inline_dockerfile"
          dockerfile_revision="$(sha256sum "$inline_dockerfile" | cut -d " " -f 1)"
          revision="$revision:$dockerfile_revision"
          log "dockerfile_revision=$dockerfile_revision inline_dockerfile=$inline_dockerfile"
        ''}
        ${lib.optionalString (image.baseImage != null) ''
          base_image=${lib.escapeShellArg image.baseImage}
          resolved_base_image="$base_image"
          ${lib.optionalString (image.baseImageTagPattern != null) ''
            base_tag_pattern=${lib.escapeShellArg image.baseImageTagPattern}
            tags_file="$state/base-image-tags.txt"
            if skopeo list-tags "docker://$base_image" > "$tags_file"; then
              log "base_tags_status=ok image=$base_image file=$tags_file"
            else
              log "base_tags_status=failed image=$base_image"
              exit 1
            fi
            latest_tag="$(
              jq -r '.Tags[]' "$tags_file" \
                | grep -E "$base_tag_pattern" \
                | sort -V \
                | tail -n 1
            )"
            if [ -z "$latest_tag" ]; then
              log "base_tag_resolve=failed image=$base_image pattern=$base_tag_pattern"
              exit 1
            fi
            resolved_base_image="$base_image:$latest_tag"
            log "base_tag_resolve=ok image=$base_image pattern=$base_tag_pattern latest_tag=$latest_tag resolved_base_image=$resolved_base_image"
            build_args+=("--build-arg" "BASE_IMAGE=$resolved_base_image")
          ''}
          base_digest="$(skopeo inspect --format '{{.Digest}}' "docker://$resolved_base_image")"
          revision="$revision:$resolved_base_image@$base_digest"
          log "base_image=$base_image resolved_base_image=$resolved_base_image base_digest=$base_digest"
        ''}

        ${imagePresentCheck}
        log "image_present=$image_present image=$image"

        if [ -f "$built_revision_file" ]; then
          built_revision="$(cat "$built_revision_file")"
          log "stored_revision=$built_revision file=$built_revision_file"
        else
          built_revision=""
          log "stored_revision=<missing> file=$built_revision_file"
        fi

        rebuild_reasons=()
        if [ "$built_revision" != "$revision" ] && [ "$ensure_only" != 1 ]; then
          rebuild_reasons+=("revision_changed")
        fi
        if [ "$image_present" != 1 ]; then
          rebuild_reasons+=("image_missing")
        fi
        if [ "''${#rebuild_reasons[@]}" -eq 0 ]; then
          log "decision=skip reason=current desired_revision=$revision"
        else
          log "decision=build reasons=''${rebuild_reasons[*]} desired_revision=$revision stored_revision=$built_revision image_present=$image_present"
        fi

        if [ "''${#rebuild_reasons[@]}" -eq 0 ]; then
          echo "Local Docker image $image is current at $revision"
          exit 0
        fi

        log "build_start image=$image build_context=$build_context"
        podman build --pull=always -t "$image" "''${build_args[@]}" ${dockerfileArg} "$build_context"
        log "build_done image=$image"
        ${lib.optionalString image.importToK3s ''
          log "import_start image=$image tar=$image_tar"
          rm -f "$image_tar"
          podman save "$image" -o "$image_tar"
          ${k3sCtr} import "$image_tar"
          rm -f "$image_tar"
          log "import_done image=$image"
        ''}
        ${lib.optionalString (image.postBuildCommands != "") ''
          log "post_build_start"
        ''}
        ${image.postBuildCommands}
        ${lib.optionalString (image.postBuildCommands != "") ''
          log "post_build_done"
        ''}
        ${lib.optionalString (image.restartKube != [ ]) ''
          log "restart_kube_start count=${toString (builtins.length image.restartKube)}"
        ''}
        ${restartKubeCommands}
        ${lib.optionalString (image.restartKube != [ ]) ''
          log "restart_kube_done"
        ''}
        printf '%s\n' "$revision" > "$built_revision_file"
        log "stored_revision_updated=$revision file=$built_revision_file"

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

  imageServiceNames = map (name: "${mkServiceName name}.service") (lib.attrNames cfg.images);
  imageEnsureServiceNames = map (name: "${mkServiceName name}-ensure.service") (
    lib.attrNames cfg.images
  );
in
{
  options.my.localDockerImages = with lib; {
    ensureSchedule = mkOption {
      type = types.str;
      default = "hourly";
      description = "systemd OnCalendar expression for checking that local images are present in k3s.";
    };

    pruneSchedule = mkOption {
      type = types.str;
      default = "daily";
      description = "systemd OnCalendar expression for pruning unused Podman build/cache data.";
    };

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

    systemd.services = lib.mkMerge [
      (lib.mapAttrs' (
        name: image: lib.nameValuePair (mkServiceName name) (mkImageService name image false)
      ) cfg.images)
      (lib.mapAttrs' (
        name: image: lib.nameValuePair "${mkServiceName name}-ensure" (mkImageService name image true)
      ) cfg.images)
      {
        local-docker-images-ensure = {
          description = "Ensure local Docker images are present in k3s";
          after = [ "k3s.service" ];
          requires = [ "k3s.service" ];

          path = [ pkgs.systemd ];

          serviceConfig = {
            Type = "oneshot";
            TimeoutStartSec = "infinity";
          };

          script = ''
            set -euo pipefail
            systemctl start ${lib.concatMapStringsSep " " lib.escapeShellArg imageEnsureServiceNames}
          '';
        };

        local-docker-images-podman-prune = {
          description = "Prune unused Podman data for local Docker images";

          path = with pkgs; [
            podman
          ];

          serviceConfig = {
            Type = "oneshot";
            TimeoutStartSec = "infinity";
          };

          script = ''
            set -euo pipefail
            podman system prune --force
            podman builder prune --all --force
          '';
        };
      }
    ];

    systemd.timers =
      lib.mapAttrs' (
        name: image: lib.nameValuePair (mkServiceName name) (mkImageTimer name image)
      ) cfg.images
      // {
        local-docker-images-ensure = {
          description = "Ensure local Docker images are present in k3s";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.ensureSchedule;
            Persistent = true;
            Unit = "local-docker-images-ensure.service";
          };
        };

        local-docker-images-podman-prune = {
          description = "Prune unused Podman data for local Docker images";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.pruneSchedule;
            Persistent = true;
            Unit = "local-docker-images-podman-prune.service";
          };
        };
      };
  };
}
