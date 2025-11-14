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

### Build the Docker image:

```bash
docker build -t simple-go-http-server .
```

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
# Deploy registry to Kubernetes and push first image
chmod +x setup-k8s-registry.sh
./setup-k8s-registry.sh

# Apply Kargo configuration
kubectl apply -f k8s/kargo/kargo.yaml

# Verify Warehouse detected the image
kubectl get freight -n poc-project
```

### Push New Versions

```bash
# Make code changes (e.g., change BoxColor in main.go)
# Then build and push new version:
chmod +x push-k8s-registry-version.sh
./push-k8s-registry-version.sh 0.0.2  # increment version

# Kargo will auto-detect the new image
# Then promote through stages:
kubectl promote --stage development --freight <freight-name> -n poc-project
```

See **[k8s/registry/README.md](k8s/registry/README.md)** for registry details and **[KARGO-WORKFLOW.md](KARGO-WORKFLOW.md)** for complete Kargo usage instructions.
