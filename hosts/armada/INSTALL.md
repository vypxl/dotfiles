# armada — Installation Guide

## TinyAuth & Pocket ID

- Open `https://id.lab.vypxl.io/setup` and create admin account

In the Pocket ID admin UI:

1. Go to **OIDC Clients** → **Create**
2. Set:
   - **Name:** `Tinyauth`
   - **Callback URL:** `https://auth.lab.vypxl.io/api/oauth/callback/pocketid`
3. Save, then generate a **Client Secret**
4. Copy the **Client ID** and **Client Secret** (the secret is shown only once)
5. Save into `sops hosts/armada/cluster/apps/auth/secrets.yaml`

## Headscale & Pocket ID

In the Pocket ID admin UI:

1. Create a `headscale` group and add the users allowed to join the tailnet.
2. Go to **OIDC Clients** -> **Create**.
3. Use:
   - **Name:** `Headscale`
   - **Callback URL:** `https://headscale.lab.vypxl.io/oidc/callback`
   - **PKCE:** enabled, method `S256`
   - **Allowed User Groups:** `headscale`
4. Save, then generate a **Client Secret**.
5. Save the **Client Secret** as `OIDC_CLIENT_SECRET` in `sops hosts/armada/cluster/apps/secrets.yaml`.
