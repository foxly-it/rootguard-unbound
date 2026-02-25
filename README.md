# RootGuard Unbound

![Build Status](https://github.com/foxly-it/rootguard-unbound/actions/workflows/build.yml/badge.svg)
![Multi-Arch](https://img.shields.io/badge/arch-amd64%20%7C%20arm64-blue)
![License](https://img.shields.io/badge/license-MIT-green)

Enterprise-grade Unbound DNS engine based on official Debian packages.

Built and published automatically via GitHub Actions to GHCR.

---

## Features

- Debian `stable-slim` base
- Official Debian `unbound` package
- Multi-architecture: `amd64` + `arm64`
- Automatic daily rebuild (Security updates)
- Runs as non-root (Debian packaged system user)
- Healthcheck included
- Minimal default configuration (`127.0.0.1:5335`)
- Designed for RootGuard integration

---

## Image

```
ghcr.io/foxly-it/rootguard-unbound:latest
```

---

## Default Configuration

The container ships with a minimal internal-only configuration:

- Interface: `127.0.0.1`
- Port: `5335`
- No external exposure
- Intended for internal use (e.g. AdGuard Home upstream)

---

## Example Docker Compose

```yaml
services:
  rootguard-unbound:
    image: ghcr.io/foxly-it/rootguard-unbound:latest
    container_name: rootguard-unbound
    restart: unless-stopped
    volumes:
      - ./unbound:/config
    network_mode: "service:rootguard-adguard"
```

---

## Security Model

- No custom UID/GID
- Uses Debian packaged `unbound` system user
- Minimal attack surface
- Daily CI rebuild for security patches

---

## Build System

This image is automatically built via GitHub Actions:

- Triggered on push to `main`
- Daily scheduled rebuild
- Multi-arch build using `docker buildx`
- Published to GHCR

---

## Roadmap

- Config override via RootGuard dashboard
- Live config validation (`unbound-checkconf`)
- Runtime reload (SIGHUP)
- SBOM + image signing
- Security scanning (Trivy)

---

## License

MIT License