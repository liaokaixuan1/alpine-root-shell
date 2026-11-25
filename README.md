# alpine-root-shell

Alpine + ttyd **root web shell**, built to run on any Docker PaaS
(Back4App Containers, Railway, Render, Fly, Koyeb, Hostless, ...).

Container runs as **uid 0 (root)** — that is the default for Docker; nothing here
drops privileges. Log in and you are root inside the container.

## What you get

- `alpine:3.21` base, ~90 MB
- `bash`, `curl`, `wget`, `git`, `ssh`, `procps`, `htop`, `vim`, `nano`, `less`, `tzdata`
- `ttyd` on `$PORT`, HTTP Basic Auth, **write enabled** (`-W`)
- Credentials printed to the deploy log and also written to `/root/.ttyd_pass`

## Run it

```bash
docker run -d -p 8080:8080 -e TTYD_PASS=changeme ghcr.io/liaokaixuan1/alpine-root-shell
# open http://localhost:8080  ->  admin / changeme
```

Environment variables:

| Var | Default | Meaning |
|---|---|---|
| `PORT` | `8080` | listen port (PaaS usually injects this) |
| `TTYD_USER` | `admin` | basic-auth user |
| `TTYD_PASS` | random 16 chars | basic-auth password |
| `TZ` | `Asia/Shanghai` | container timezone |

## Deploy on Back4App Containers

1. Dashboard → **Web Deployment** → connect GitHub → pick this repo, branch `main`, root `/`.
2. The Dockerfile is detected automatically; no build command, no start command.
3. Add env `TTYD_PASS` in the app settings if you want a fixed password.
4. Create the app, open the `.b4a.run` URL, log in.

> **Free plan caveat:** the free URL is temporary — it lives **60 minutes from the
> moment the deploy starts**, then the container is destroyed
> (`The Back4app custom domain has expired for free plan` → `DEPLOYMENT DESTROYED`).
> A redeploy only restarts the clock. Permanent URLs need the paid Shared plan ($5/mo).

## Security

This is a **root shell exposed over HTTP**. Anyone who reaches the URL and knows the
password owns the container. Always set a strong `TTYD_PASS`; the container is
disposable, but it can reach your other services from inside the platform network.