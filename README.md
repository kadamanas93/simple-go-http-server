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

## Kubernetes

Deploy to your local Kubernetes cluster (Colima, Minikube, Kind, etc.):

```bash
# Deploy the application
kubectl apply -f k8s-deployment.yaml

# Check status
kubectl get pods
kubectl get svc

# Get the service URL (if using Colima)
kubectl get svc simple-go-http-server

# Access the app
# For NodePort: http://localhost:<node-port>
# Get node port with: kubectl get svc simple-go-http-server -o jsonpath='{.spec.ports[0].nodePort}'
```

### Using with Docker Registry

See **[REGISTRY-GUIDE.md](REGISTRY-GUIDE.md)** for complete instructions on:

- 🏠 **Local Docker Registry** - Run a registry locally
- 🐳 **Docker Hub** - Push to Docker Hub (free tier)
- 🐙 **GitHub Container Registry (GHCR)** - Unlimited free repos
- ⚡ **Colima Direct** - Use images without a registry (easiest!)

Quick start for local registry:

```bash
# Setup local registry
chmod +x local-registry-setup.sh
./local-registry-setup.sh

# Build and push
chmod +x push-to-local-registry.sh
./push-to-local-registry.sh
```
