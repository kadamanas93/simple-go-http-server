#!/bin/bash

# Setup script for local Docker registry

set -e

echo "🚀 Setting up local Docker registry..."

# Start local registry on port 5000
docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  registry:2

echo "✅ Local registry running on localhost:5000"
echo ""
echo "To use it:"
echo "1. Tag your image: docker tag simple-go-http-server localhost:5000/simple-go-http-server"
echo "2. Push to registry: docker push localhost:5000/simple-go-http-server"
echo "3. Use in k8s: image: localhost:5000/simple-go-http-server"

