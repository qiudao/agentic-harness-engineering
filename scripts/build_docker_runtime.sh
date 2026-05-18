#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HARNESS_ROOT="$(cd "$PROJECT_ROOT/.." && pwd)"
CONTEXT_DIR="$PROJECT_ROOT/docker/ahe-runtime"
IMAGE_TAG="${1:-ahe-nexau-runtime:local}"

mkdir -p "$CONTEXT_DIR"

if [[ ! -d "$HARNESS_ROOT/NexAU" ]]; then
  echo "Missing local NexAU repo: $HARNESS_ROOT/NexAU" >&2
  exit 1
fi

if [[ ! -f "$HARNESS_ROOT/_downloads/ahe-runtime/NexAU-harbor.tar.gz" ]]; then
  echo "Missing NexAU-harbor tarball: $HARNESS_ROOT/_downloads/ahe-runtime/NexAU-harbor.tar.gz" >&2
  exit 1
fi

tar --exclude='.git' --exclude='build' --exclude='dist' --exclude='*.egg-info' \
  -czf "$CONTEXT_DIR/NexAU-local.tar.gz" \
  -C "$HARNESS_ROOT" NexAU

cp "$HARNESS_ROOT/_downloads/ahe-runtime/NexAU-harbor.tar.gz" "$CONTEXT_DIR/NexAU-harbor.tar.gz"

DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}" \
DOCKER_HOST="${DOCKER_HOST:-unix://$HOME/.docker/run/docker.sock}" \
docker build \
  --build-arg PIP_INDEX_URL="${PIP_INDEX_URL:-https://pypi.tuna.tsinghua.edu.cn/simple}" \
  -t "$IMAGE_TAG" \
  "$CONTEXT_DIR"

echo "Built $IMAGE_TAG"
