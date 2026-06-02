# Dockerfile Optimization Playground

This repository contains an image and helper scripts/workflow to experiment with Dockerfile optimization techniques. The current `Dockerfile` has been optimized to reduce image size while preserving the same tooling and runtime behavior.

Files added:
- [Dockerfile](Dockerfile) — image used for optimization practice (now optimized).
- [.github/workflows/build_upload_container.yaml](.github/workflows/build_upload_container.yaml) — GitHub Actions workflow to build and push the image.
- [src/runs.sh](src/runs.sh) — helper to run the image locally.
- [build_container.sh](build_container.sh) — local build helper.
- [push_to_registry.sh](push_to_registry.sh) — tag and push helper (supports GHCR and Docker Hub credentials).

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

Docker Hub push example:
```bash
export REGISTRY=docker.io
export REPO=youruser/yourrepo
export DOCKERHUB_USERNAME=youruser
export DOCKERHUB_PASSWORD=yourpassword
./push_to_registry.sh
```

GitHub Actions:
- The workflow runs on pushes to `main` (or manual dispatch).
- It now pushes to Docker Hub using `secrets.DOCKERHUB_USERNAME` and `secrets.DOCKERHUB_PASSWORD`.

Next steps:
- Use this heavy Dockerfile to try layer-squashing, multistage builds, caching strategies, and smaller base images.
