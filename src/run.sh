#!/usr/bin/env bash
set -euo pipefail

# Simple helper to run the image locally for testing
IMAGE=${IMAGE:-dockerfile_optimization:heavy}

echo "Running container from image: $IMAGE"
docker run --rm -it -p 8080:8080 "$IMAGE" /bin/bash -lc "echo 'Container started'; bash"
