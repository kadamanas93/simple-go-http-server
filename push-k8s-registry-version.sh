#!/bin/bash

# Push new version to Kubernetes-hosted registry

set -e

if [ -z "$1" ]; then
    echo "Usage: ./push-k8s-registry-version.sh <version>"
    echo "Example: ./push-k8s-registry-version.sh 0.0.2"
    exit 1
fi

VERSION=$(cat .version)

echo "🔍 Checking if port-forward is running..."
if ! pgrep -f "kubectl port-forward.*registry" > /dev/null; then
    echo "⚠️  Port-forward not running. Starting it..."
    kubectl port-forward -n registry service/docker-registry 5000:5000 > /dev/null 2>&1 &
    echo "   Started port-forward (PID: $!)"
    sleep 3
fi

# Test registry access
if ! curl -s http://localhost:5000/v2/ > /dev/null; then
    echo "❌ Cannot reach registry at localhost:5000"
    echo "   Make sure port-forward is running:"
    echo "   kubectl port-forward -n registry service/docker-registry 5000:5000"
    exit 1
fi

echo "🔨 Building image version $VERSION..."
docker build -t simple-go-http-server:$VERSION .

echo "🏷️  Tagging for registry..."
docker tag simple-go-http-server:$VERSION localhost:5000/simple-go-http-server:$VERSION
docker tag simple-go-http-server:$VERSION localhost:5000/simple-go-http-server:latest

echo "📤 Pushing to Kubernetes registry..."
docker push localhost:5000/simple-go-http-server:$VERSION
docker push localhost:5000/simple-go-http-server:latest

echo ""
echo "✅ Version $VERSION pushed to registry!"
echo ""
echo "🔍 Kargo will automatically detect this new image!"
echo "   Check with: kubectl get freight -n poc-project"

