#!/bin/bash

# Script to build and push multi-architecture Docker image
# Usage: ./build-multi-arch.sh [--no-push]
# Example: ./build-multi-arch.sh
# Example: ./build-multi-arch.sh --no-push  (build only, don't push)

set -e

VERSION=$(cat .version)
IMAGE_NAME="ghcr.io/kadamanas93/simple-go-http-server"
NO_PUSH=${1:-""}

echo "Building multi-architecture image: ${IMAGE_NAME}:${VERSION}"
echo "Platforms: linux/amd64, linux/arm64"

# Check if buildx builder exists, create if not
if ! docker buildx ls | grep -q multiarch; then
    echo "Creating buildx builder 'multiarch'..."
    docker buildx create --name multiarch --use
    docker buildx inspect --bootstrap
else
    echo "Using existing buildx builder 'multiarch'..."
    docker buildx use multiarch
fi

# Build arguments
BUILD_ARGS=(--platform "linux/amd64,linux/arm64" -t "${IMAGE_NAME}:${VERSION}")

# Add latest tag if version is not "latest"
if [ "$VERSION" != "latest" ]; then
    BUILD_ARGS+=(-t "${IMAGE_NAME}:latest")
fi

# Add push flag unless --no-push is specified
if [ "$NO_PUSH" != "--no-push" ]; then
    BUILD_ARGS+=(--push)
    echo "Will push to registry after build"
else
    echo "⚠️  Building only (--no-push specified)"
    echo "Note: Multi-arch images cannot be loaded locally. Use --push to create the manifest."
    # Don't add --load for multi-arch, it only works for single platform
fi

BUILD_ARGS+=(.)

# Execute build
echo "Starting build..."
docker buildx build "${BUILD_ARGS[@]}"

if [ "$NO_PUSH" != "--no-push" ]; then
    echo ""
    echo "✅ Build and push complete!"
    echo "Image: ${IMAGE_NAME}:${VERSION}"
    echo ""
    echo "To verify the manifest:"
    echo "  docker manifest inspect ${IMAGE_NAME}:${VERSION}"
else
    echo ""
    echo "⚠️  Build completed but not pushed."
    echo "Multi-arch images must be pushed to a registry to create the manifest."
    echo "Run without --no-push to push: ./build-multi-arch.sh ${VERSION}"
fi

