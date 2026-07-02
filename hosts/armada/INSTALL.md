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

## Headplane & Pocket ID

Headplane is served at `https://headscale.lab.vypxl.io/admin`.

In the Pocket ID admin UI:

1. Either add this callback URL to the existing `Headscale` OIDC client, or create a new `Headplane` OIDC client:
   - **Callback URL:** `https://headscale.lab.vypxl.io/admin/oidc/callback`
   - **PKCE:** enabled, method `S256`
   - **Allowed User Groups:** `headscale`
2. Save, then generate a **Client Secret**.
3. Generate a long-lived Headscale API key:

   ```bash
   kubectl exec -n default sts/headscale -c headscale -- headscale apikeys create --expiration 8760h
   ```

4. Create a `headplane` secret in `sops hosts/armada/cluster/apps/secrets.yaml` with:
   - `HEADPLANE_SERVER__COOKIE_SECRET`: exactly 32 random characters
   - `HEADPLANE_HEADSCALE__API_KEY`: Headscale API key from step 3
   - `HEADPLANE_OIDC__CLIENT_ID`: Pocket ID client ID
   - `HEADPLANE_OIDC__CLIENT_SECRET`: Pocket ID client secret

## Headlamp & Pocket ID

In the Pocket ID admin UI:

1. Create a `admin` group and add users allowed to administer the cluster.
2. Go to **OIDC Clients** and create or edit the `Kubernetes / Headlamp` client.
3. Use:
   - **Name:** `Kubernetes / Headlamp`
   - **Callback URL:** `https://headlamp.lab.vypxl.io/oidc-callback`
   - **PKCE:** enabled
   - **Allowed User Groups:** `admin`
   - **Client ID:** `kubernetes`
4. Save, then generate a **Client Secret**.
5. Save the **Client Secret** as `OIDC_CLIENT_SECRET` in `sops hosts/armada/cluster/apps/secrets.yaml`.
6. Make sure every user in the `admin` group has their **email marked as verified** in Pocket ID.
