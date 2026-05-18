#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HARNESS_ROOT="$(cd "$PROJECT_ROOT/.." && pwd)"
CONTEXT_DIR="$PROJECT_ROOT/docker/ahe-bench-sample-runtime"
IMAGE_TAG="${1:-ahe-bench-sample-runtime:local}"
ALPINE_ISO="alpine-extended-3.19.0-x86_64.iso"
NOTO_FONT="NotoSansSymbols2-Regular.ttf"
CACHE_DIR="$HARNESS_ROOT/_downloads/terminal-bench-sample"

mkdir -p "$CACHE_DIR" "$CONTEXT_DIR"

if [[ ! -f "$CACHE_DIR/$ALPINE_ISO" ]]; then
  curl -L --retry 5 --retry-delay 5 \
    "https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/$ALPINE_ISO" \
    -o "$CACHE_DIR/$ALPINE_ISO"
fi

if [[ ! -f "$CACHE_DIR/$NOTO_FONT" ]]; then
  curl -L --retry 5 --retry-delay 5 \
    "https://notofonts.github.io/symbols/fonts/NotoSansSymbols2/full/ttf/$NOTO_FONT" \
    -o "$CACHE_DIR/$NOTO_FONT"
fi

cp "$CACHE_DIR/$ALPINE_ISO" "$CONTEXT_DIR/$ALPINE_ISO"
cp "$CACHE_DIR/$NOTO_FONT" "$CONTEXT_DIR/$NOTO_FONT"

DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}" \
DOCKER_HOST="${DOCKER_HOST:-unix://$HOME/.docker/run/docker.sock}" \
docker build \
  --build-arg PIP_INDEX_URL="${PIP_INDEX_URL:-https://pypi.tuna.tsinghua.edu.cn/simple}" \
  -t "$IMAGE_TAG" \
  "$CONTEXT_DIR"

echo "Built $IMAGE_TAG"
