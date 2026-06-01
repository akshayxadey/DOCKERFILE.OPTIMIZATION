#!/usr/bin/env bash
set -euo pipefail

IMAGE=${IMAGE:-dockerfile_optimization:heavy}
DOCKERFILE=${DOCKERFILE:-Dockerfile.heavy}

echo "Building $IMAGE using $DOCKERFILE"
docker build -f "$DOCKERFILE" -t "$IMAGE" .
echo "Build complete: $IMAGE"
