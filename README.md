# simple-go-http-server

A simple Go HTTP server that displays a colored box. The color can be easily changed by modifying a constant in the code.

## Features

- 🎨 Displays a beautiful colored box
- 🔧 Easy to customize - just change the `BoxColor` constant
- 🚀 Lightweight and fast
- 💅 Modern, responsive design

## How to Run

1. Make sure you have Go installed (version 1.21 or higher)
2. Navigate to this directory
3. Run the server:

   ```bash
   go run main.go
   ```

4. Open your browser and visit: http://localhost:8080

## How to Change the Color

Open `main.go` and modify the `BoxColor` constant (line 10):

```go
const BoxColor = "blue"  // Change this to any color!
```

You can use:

- Color names: `"red"`, `"blue"`, `"green"`, `"purple"`, `"orange"`, etc.
- Hex codes: `"#FF5733"`, `"#3498db"`, `"#2ecc71"`, etc.
- RGB values: `"rgb(255, 87, 51)"`, etc.

After changing the color, restart the server to see the changes.

## Building

To build a standalone executable:

```bash
go build -o server
./server
```

## Docker

### Build the Docker image (single architecture):

```bash
docker build -t simple-go-http-server .
```

### Build multi-architecture image (arm64 + amd64):

To build an image that works on both ARM64 (Apple Silicon) and AMD64 (Intel) architectures:

1. **Set up Docker buildx** (if not already done):
   ```bash
   docker buildx create --name multiarch --use
   docker buildx inspect --bootstrap
   ```

2. **Login to GitHub Container Registry**:
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u kadamanas93 --password-stdin
   ```
   (Replace `$GITHUB_TOKEN` with your GitHub Personal Access Token with `write:packages` permission)

3. **Build and push multi-architecture image**:
   ```bash
   docker buildx build \
     --platform linux/amd64,linux/arm64 \
     -t ghcr.io/kadamanas93/simple-go-http-server:0.0.7 \
     -t ghcr.io/kadamanas93/simple-go-http-server:latest \
     --push \
     .
   ```

   Or for a specific version:
   ```bash
   VERSION=0.0.7
   docker buildx build \
     --platform linux/amd64,linux/arm64 \
     -t ghcr.io/kadamanas93/simple-go-http-server:${VERSION} \
     --push \
     .
   ```

4. **Verify the multi-architecture manifest**:
   ```bash
   docker manifest inspect ghcr.io/kadamanas93/simple-go-http-server:0.0.7
   ```
   You should see both `linux/amd64` and `linux/arm64` in the output.

### Run the container:

```bash
docker run -p 8090:8090 simple-go-http-server
```

Then open your browser and visit: http://localhost:8090

### Run in detached mode (background):

```bash
docker run -d -p 8090:8090 --name color-box simple-go-http-server
```

### Stop the container:

```bash
docker stop color-box
docker rm color-box
```

## Kubernetes with Kargo

This project uses Kargo for progressive delivery through dev → staging → prod stages.

### Initial Setup

```bash
# Apply Kargo configuration
kubectl apply -f k8s/kargo/kargo.yaml

# Verify Warehouse detected the image
kubectl get freight -n poc-project
```
