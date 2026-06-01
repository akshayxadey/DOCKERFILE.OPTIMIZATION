# Dockerfile Optimization Playground

This repository contains a deliberately heavy Dockerfile and helper scripts/workflow to experiment with Dockerfile optimization techniques.

Files added:
- [Dockerfile.heavy](Dockerfile.heavy) — intentionally large image for optimization practice.
- [.github/workflows/build_upload_container.yaml](.github/workflows/build_upload_container.yaml) — GitHub Actions workflow to build and push the image.
- [src/runs.sh](src/runs.sh) — helper to run the image locally.
- [build_container.sh](build_container.sh) — local build helper.
- [push_to_registry.sh](push_to_registry.sh) — tag and push helper (uses `REGISTRY_USERNAME` and `REGISTRY_TOKEN`).

Quick start:

1. Build locally:
```bash
./build_container.sh
```

2. Run locally:
```bash
./src/runs.sh
```

3. Push to registry (set env vars first):
```bash
export REGISTRY=ghcr.io
export REPO=youruser/yourrepo
export REGISTRY_USERNAME=youruser
export REGISTRY_TOKEN=yourtoken
./push_to_registry.sh
```

GitHub Actions:
- The workflow runs on pushes to `main` (or manual dispatch). Set `secrets.REGISTRY_USERNAME` and `secrets.REGISTRY_TOKEN` in repository Secrets to enable pushing.

Next steps:
- Use this heavy Dockerfile to try layer-squashing, multistage builds, caching strategies, and smaller base images.
