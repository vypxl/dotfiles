{
  config,
  hermes-agent,
  lib,
  pkgs,
  ...
}:
let
  armadaState = "/var/lib/armada";

  composeService =
    {
      name,
      composeFile,
      envFile ? null,
      after ? [ ],
      preStart ? "",
    }:
    let
      projectDir = "${armadaState}/${name}";
      envArgs = lib.optionalString (envFile != null) "--env-file ${envFile}";
      composeArgs = "--project-directory ${projectDir} ${envArgs} -f ${composeFile}";
    in
    {
      description = "Armada ${name} Docker Compose stack";
      wantedBy = [ "multi-user.target" ];
      after = [
        "docker.service"
        "network-online.target"
      ]
      ++ after;
      wants = [ "network-online.target" ];
      requires = [ "docker.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = projectDir;
        ExecStart = pkgs.writeShellScript "armada-${name}-up" ''
          set -eu
          mkdir -p ${projectDir}
          ${preStart}
          ${pkgs.docker}/bin/docker compose ${composeArgs} up -d --build --remove-orphans
        '';
        ExecStop = pkgs.writeShellScript "armada-${name}-down" ''
          set -eu
          ${pkgs.docker}/bin/docker compose ${composeArgs} down
        '';
      };
      restartTriggers = [ composeFile ];
    };

  firecrawlCompose = pkgs.writeText "firecrawl-compose.yaml" ''
    name: armada-firecrawl

    x-common-service: &common-service
      image: ghcr.io/firecrawl/firecrawl:latest
      ulimits:
        nofile:
          soft: 65535
          hard: 65535
      extra_hosts:
        - "host.docker.internal:host-gateway"

    x-common-env: &common-env
      REDIS_URL: redis://redis:6379
      REDIS_RATE_LIMIT_URL: redis://redis:6379
      PLAYWRIGHT_MICROSERVICE_URL: http://playwright-service:3000/scrape
      NUQ_DATABASE_URL: ''${NUQ_DATABASE_URL}
      USE_DB_AUTHENTICATION: ''${USE_DB_AUTHENTICATION:-false}
      OPENAI_API_KEY: ''${OPENAI_API_KEY:-}
      OPENAI_BASE_URL: ''${OPENAI_BASE_URL:-}
      MODEL_NAME: ''${MODEL_NAME:-}
      MODEL_EMBEDDING_NAME: ''${MODEL_EMBEDDING_NAME:-}
      OLLAMA_BASE_URL: ''${OLLAMA_BASE_URL:-}
      SLACK_WEBHOOK_URL: ''${SLACK_WEBHOOK_URL:-}
      BULL_AUTH_KEY: ''${BULL_AUTH_KEY}
      TEST_API_KEY: ''${TEST_API_KEY:-}
      POSTHOG_API_KEY: ''${POSTHOG_API_KEY:-}
      POSTHOG_HOST: ''${POSTHOG_HOST:-}
      SUPABASE_ANON_TOKEN: ''${SUPABASE_ANON_TOKEN:-}
      SUPABASE_URL: ''${SUPABASE_URL:-}
      SUPABASE_SERVICE_TOKEN: ''${SUPABASE_SERVICE_TOKEN:-}
      SELF_HOSTED_WEBHOOK_URL: ''${SELF_HOSTED_WEBHOOK_URL:-}
      SERPER_API_KEY: ''${SERPER_API_KEY:-}
      SEARCHAPI_API_KEY: ''${SEARCHAPI_API_KEY:-}
      LOGGING_LEVEL: ''${LOGGING_LEVEL:-INFO}
      PROXY_SERVER: ''${PROXY_SERVER:-}
      PROXY_USERNAME: ''${PROXY_USERNAME:-}
      PROXY_PASSWORD: ''${PROXY_PASSWORD:-}
      NO_PROXY: localhost,127.0.0.1,redis,nuq-postgres,playwright-service,host.docker.internal
      SEARXNG_ENDPOINT: ''${SEARXNG_ENDPOINT:-}
      SEARXNG_ENGINES: ''${SEARXNG_ENGINES:-}
      SEARXNG_CATEGORIES: ''${SEARXNG_CATEGORIES:-}

    services:
      playwright-service:
        image: ghcr.io/firecrawl/playwright-service:latest
        shm_size: "1g"
        restart: unless-stopped
        environment:
          PORT: 3000
          PROXY_SERVER: ''${PROXY_SERVER:-}
          PROXY_USERNAME: ''${PROXY_USERNAME:-}
          PROXY_PASSWORD: ''${PROXY_PASSWORD:-}
          BLOCK_MEDIA: ''${BLOCK_MEDIA:-}
          NO_PROXY: localhost,127.0.0.1,redis,nuq-postgres,playwright-service,host.docker.internal

      api:
        <<: *common-service
        restart: unless-stopped
        ports:
          - "127.0.0.1:3002:3002"
        environment:
          <<: *common-env
          HOST: "0.0.0.0"
          PORT: 3002
          WORKER_PORT: 3005
          ENV: local
        depends_on:
          redis:
            condition: service_started
          playwright-service:
            condition: service_started
          nuq-postgres:
            condition: service_healthy
        command: node --import ./dist/src/otel.js dist/src/index.js

      worker:
        <<: *common-service
        restart: unless-stopped
        environment:
          <<: *common-env
          HOST: "0.0.0.0"
          PORT: 3005
          ENV: local
        depends_on:
          redis:
            condition: service_started
          nuq-postgres:
            condition: service_healthy
        command: node --import ./dist/src/otel.js dist/src/services/queue-worker.js

      extract-worker:
        <<: *common-service
        restart: unless-stopped
        environment:
          <<: *common-env
          HOST: "0.0.0.0"
          PORT: 3004
          ENV: local
        depends_on:
          redis:
            condition: service_started
          nuq-postgres:
            condition: service_healthy
        command: node --import ./dist/src/otel.js dist/src/services/extract-worker.js

      redis:
        image: redis:alpine
        command: redis-server --bind 0.0.0.0
        restart: unless-stopped

      nuq-postgres:
        build:
          context: "https://github.com/firecrawl/firecrawl.git#main:apps/nuq-postgres"
          dockerfile: Dockerfile
        restart: unless-stopped
        environment:
          POSTGRES_USER: ''${POSTGRES_USER}
          POSTGRES_PASSWORD: ''${POSTGRES_PASSWORD}
          POSTGRES_DB: ''${POSTGRES_DB}
        volumes:
          - nuq_pg_data:/var/lib/postgresql/data
        healthcheck:
          test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}"]
          start_period: 30s
          interval: 10s
          timeout: 5s
          retries: 10

    volumes:
      nuq_pg_data:
  '';

  hindsightCompose = pkgs.writeText "hindsight-compose.yaml" ''
    name: armada-hindsight

    services:
      hindsight:
        image: ghcr.io/vectorize-io/hindsight:latest
        restart: unless-stopped
        ports:
          - "127.0.0.1:8888:8888"
          - "127.0.0.1:9999:9999"
        environment:
          HINDSIGHT_API_LLM_PROVIDER: ''${HINDSIGHT_API_LLM_PROVIDER:-openai}
          HINDSIGHT_API_LLM_API_KEY: ''${HINDSIGHT_API_LLM_API_KEY}
        volumes:
          - hindsight_data:/home/hindsight/.pg0

    volumes:
      hindsight_data:
  '';

  obsidianLiveSyncIni = pkgs.writeText "obsidian-livesync.ini" ''
    [couchdb]
    single_node = true
    max_document_size = 50000000

    [chttpd]
    bind_address = any
    port = 5984
    require_valid_user = true
    max_http_request_size = 4294967296
    enable_cors = true

    [httpd]
    enable_cors = true

    [cors]
    credentials = true
    origins = app://obsidian.md,capacitor://localhost,http://localhost
    headers = accept, authorization, content-type, origin, referer
    methods = GET, PUT, POST, HEAD, DELETE

    [feature_flags]
    partitioned||* = true
  '';

  obsidianLiveSyncCompose = pkgs.writeText "obsidian-livesync-compose.yaml" ''
    name: armada-obsidian-livesync

    services:
      couchdb:
        image: couchdb:latest
        container_name: obsidian-livesync
        user: "5984:5984"
        restart: unless-stopped
        ports:
          - "5984:5984"
        environment:
          COUCHDB_USER: ''${COUCHDB_USER}
          COUCHDB_PASSWORD: ''${COUCHDB_PASSWORD}
        volumes:
          - couchdb_data:/opt/couchdb/data
          - ${obsidianLiveSyncIni}:/opt/couchdb/etc/local.d/10-obsidian-livesync.ini:ro

    volumes:
      couchdb_data:
  '';

  actuallyBotCompose = pkgs.writeText "actually-bot-compose.yaml" ''
    name: armada-actually-bot

    services:
      actually-bot:
        build:
          context: ./src
        restart: unless-stopped
        env_file:
          - ./.env
  '';

  hermesPackage = hermes-agent.packages.${pkgs.system}.default;
in
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      firecrawl-bull-auth-key = { };
      firecrawl-postgres-password = { };
      hindsight-llm-api-key = { };
      obsidian-livesync-user = { };
      obsidian-livesync-password = { };
      hermes-openrouter-api-key = {
        owner = "hermes";
      };
      actually-bot-deploy-key = {
        mode = "0400";
      };
      actually-bot-token = { };
    };

    templates = {
      "firecrawl.env".content = ''
        USE_DB_AUTHENTICATION=false
        BULL_AUTH_KEY=${config.sops.placeholder."firecrawl-bull-auth-key"}
        POSTGRES_USER=firecrawl
        POSTGRES_PASSWORD=${config.sops.placeholder."firecrawl-postgres-password"}
        POSTGRES_DB=firecrawl
        NUQ_DATABASE_URL=postgres://firecrawl:${
          config.sops.placeholder."firecrawl-postgres-password"
        }@nuq-postgres:5432/firecrawl
      '';

      "hindsight.env".content = ''
        HINDSIGHT_API_LLM_PROVIDER=openai
        HINDSIGHT_API_LLM_API_KEY=${config.sops.placeholder."hindsight-llm-api-key"}
      '';

      "obsidian-livesync.env".content = ''
        COUCHDB_USER=${config.sops.placeholder."obsidian-livesync-user"}
        COUCHDB_PASSWORD=${config.sops.placeholder."obsidian-livesync-password"}
      '';

      "hermes.env" = {
        owner = "hermes";
        mode = "0400";
        content = ''
          OPENROUTER_API_KEY=${config.sops.placeholder."hermes-openrouter-api-key"}
        '';
      };

      "actually-bot.env".content = ''
        ACTUALLY_BOT_TOKEN=${config.sops.placeholder."actually-bot-token"}
      '';
    };
  };

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    environmentFiles = [ config.sops.templates."hermes.env".path ];
    container = {
      enable = true;
      backend = "docker";
      hostUsers = [ "thomas" ];
    };
    settings = {
      model.default = "openrouter/anthropic/claude-sonnet-4";
      terminal = {
        backend = "local";
        timeout = 180;
      };
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${armadaState} 0755 root root - -"
  ];

  systemd.services = {
    armada-firecrawl = composeService {
      name = "firecrawl";
      composeFile = firecrawlCompose;
      envFile = config.sops.templates."firecrawl.env".path;
    };

    armada-hindsight = composeService {
      name = "hindsight";
      composeFile = hindsightCompose;
      envFile = config.sops.templates."hindsight.env".path;
    };

    armada-obsidian-livesync = composeService {
      name = "obsidian-livesync";
      composeFile = obsidianLiveSyncCompose;
      envFile = config.sops.templates."obsidian-livesync.env".path;
    };

    armada-actually-bot = composeService {
      name = "actually-bot";
      composeFile = actuallyBotCompose;
      envFile = config.sops.templates."actually-bot.env".path;
      preStart = ''
        install -m 0400 ${
          config.sops.secrets."actually-bot-deploy-key".path
        } ${armadaState}/actually-bot/deploy_key
        export GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh -i ${armadaState}/actually-bot/deploy_key -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"
        if [ ! -d ${armadaState}/actually-bot/src/.git ]; then
          ${pkgs.git}/bin/git clone git@github.com:vypxl/actually_bot.git ${armadaState}/actually-bot/src
        else
          ${pkgs.git}/bin/git -C ${armadaState}/actually-bot/src pull --ff-only
        fi
        cp ${config.sops.templates."actually-bot.env".path} ${armadaState}/actually-bot/.env
      '';
    };

    hermes-dashboard = {
      description = "Hermes web dashboard";
      wantedBy = [ "multi-user.target" ];
      after = [
        "hermes-agent.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        User = "hermes";
        Group = "hermes";
        Environment = [
          "HERMES_HOME=/var/lib/hermes/.hermes"
          "HERMES_MANAGED=true"
        ];
        EnvironmentFile = config.sops.templates."hermes.env".path;
        ExecStart = "${hermesPackage}/bin/hermes dashboard --host 127.0.0.1 --port 9119 --no-open";
        Restart = "on-failure";
        RestartSec = 5;
        WorkingDirectory = "/var/lib/hermes";
      };
    };
  };
}
