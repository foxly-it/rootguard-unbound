# RootGuard Unbound

![Build Status](https://github.com/foxly-it/rootguard-unbound/actions/workflows/build.yml/badge.svg)
![Multi-Arch](https://img.shields.io/badge/arch-amd64%20%7C%20arm64-blue)
![License](https://img.shields.io/badge/license-MIT-green)

Enterprise-grade Unbound DNS engine based on official Debian packages.

Built automatically via GitHub Actions and published to GHCR.

---

## Image

```
ghcr.io/foxly-it/rootguard-unbound
```

### Available Tags

The image is automatically tagged using the official Debian Unbound package version.

Example (if Debian provides `1.22.0-2+deb13u1`):

```
latest
1.22.0-2-deb13u1
1.22.0
1.22
```

This guarantees:

- Alignment with official Debian package versions
- Transparent version traceability
- Automatic security updates via scheduled rebuilds

---

## Features

- Debian `stable-slim` base
- Official Debian `unbound` package
- Multi-architecture: `amd64` + `arm64`
- Automatic daily rebuild (security updates)
- Version tagging based on Debian package version
- Runs as Debian packaged `unbound` system user
- Healthcheck included
- Minimal default configuration (`127.0.0.1:5335`)
- Designed for RootGuard integration

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
- Automatic version tracking
- Daily CI rebuild for security patches

---

## Build System

This image is automatically built via GitHub Actions:

- Triggered on push to `main`
- Daily scheduled rebuild
- Multi-arch build using `docker buildx`
- Debian package version automatically extracted
- Published to GHCR

---

## Roadmap

- Config override via RootGuard dashboard
- Live config validation (`unbound-checkconf`)
- Runtime reload (SIGHUP)
- Read-only filesystem hardening
- SBOM generation
- Image signing (Cosign)
- Security scanning (Trivy)

---

## License

MIT License