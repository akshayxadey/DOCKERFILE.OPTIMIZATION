#!/usr/bin/env bash
set -euo pipefail

IMAGE=${IMAGE:-dockerfile_optimization:light}
DOCKERFILE=${DOCKERFILE:-Dockerfile}

echo "Building $IMAGE using $DOCKERFILE"
docker build -f "$DOCKERFILE" -t "$IMAGE" .
echo "Build complete: $IMAGE"