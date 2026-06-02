#!/usr/bin/env bash
set -euo pipefail

# Usage: set REGISTRY, REPO, and credentials env vars, then run this script.
# Supports GHCR (ghcr.io) and Docker Hub (docker.io). For Docker Hub, set
# DOCKERHUB_USERNAME and DOCKERHUB_PASSWORD (or reuse REGISTRY_USERNAME/REGISTRY_TOKEN).
IMAGE=${IMAGE:-dockerfile_optimization:light}
REGISTRY=${REGISTRY:-ghcr.io}
REPO=${REPO:-${GITHUB_REPOSITORY:-akshayxadey/DOCKERFILE.OPTIMIZATION}}
TAG=${TAG:-light-$(git rev-parse --short HEAD 2>/dev/null || echo latest)}

FULL_TAG=${FULL_TAG:-${REGISTRY}/${REPO}:${TAG}}

echo "Tagging $IMAGE -> $FULL_TAG"
docker tag "$IMAGE" "$FULL_TAG"

# Resolve credentials based on registry
if [[ "$REGISTRY" == "docker.io" || "$REGISTRY" == "index.docker.io" ]]; then
  USER=${DOCKERHUB_USERNAME:-${REGISTRY_USERNAME:-}}
  TOKEN=${DOCKERHUB_PASSWORD:-${REGISTRY_TOKEN:-}}
else
  USER=${REGISTRY_USERNAME:-}
  TOKEN=${REGISTRY_TOKEN:-}
fi

if [[ -z "${USER:-}" || -z "${TOKEN:-}" ]]; then
  echo "Please set credentials. For GHCR set REGISTRY_USERNAME and REGISTRY_TOKEN; for Docker Hub set DOCKERHUB_USERNAME and DOCKERHUB_PASSWORD (or reuse REGISTRY_* vars)."
  exit 1
fi

echo "Logging in to $REGISTRY as $USER"
if [[ "$REGISTRY" == "docker.io" || "$REGISTRY" == "index.docker.io" ]]; then
  echo "$TOKEN" | docker login -u "$USER" --password-stdin
else
  echo "$TOKEN" | docker login "$REGISTRY" -u "$USER" --password-stdin
fi

echo "Pushing $FULL_TAG"
docker push "$FULL_TAG"

echo "Push complete"
