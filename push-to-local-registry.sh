#!/bin/bash

# Script to build and push to local registry

set -e

VERSION=$(cat .version)
IMAGE_NAME="simple-go-http-server:$VERSION"
REGISTRY="localhost:5000"

echo "🔨 Building Docker image..."
docker build -t $IMAGE_NAME .

echo "🏷️  Tagging image for local registry..."
docker tag $IMAGE_NAME $REGISTRY/$IMAGE_NAME

echo "📤 Pushing to local registry..."
docker push $REGISTRY/$IMAGE_NAME

echo "✅ Done! Image available at: $REGISTRY/$IMAGE_NAME"
echo ""
echo "Use in Kubernetes deployment:"
echo "  image: $REGISTRY/$IMAGE_NAME"

