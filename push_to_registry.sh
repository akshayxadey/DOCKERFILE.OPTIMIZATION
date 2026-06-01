#!/usr/bin/env bash
set -euo pipefail

# Usage: set REGISTRY, REPO, REGISTRY_USERNAME, REGISTRY_TOKEN env vars, then run this script.
IMAGE=${IMAGE:-dockerfile_optimization:heavy}
REGISTRY=${REGISTRY:-ghcr.io}
REPO=${REPO:-${GITHUB_REPOSITORY:-akshayxadey/DOCKERFILE.OPTIMIZATION}}
TAG=${TAG:-heavy-$(git rev-parse --short HEAD 2>/dev/null || echo latest)}

FULL_TAG=${FULL_TAG:-${REGISTRY}/${REPO}:${TAG}}

echo "Tagging $IMAGE -> $FULL_TAG"
docker tag "$IMAGE" "$FULL_TAG"

if [[ -z "${REGISTRY_USERNAME:-}" || -z "${REGISTRY_TOKEN:-}" ]]; then
  echo "Please set REGISTRY_USERNAME and REGISTRY_TOKEN environment variables for login"
  exit 1
fi

echo "Logging in to $REGISTRY"
echo "$REGISTRY_TOKEN" | docker login "$REGISTRY" -u "$REGISTRY_USERNAME" --password-stdin

echo "Pushing $FULL_TAG"
docker push "$FULL_TAG"

echo "Push complete"
