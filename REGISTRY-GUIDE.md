# Docker Registry Options for Local Kubernetes

## Option 1: Local Docker Registry (Recommended for Local Dev)

**Pros:** Fast, private, no internet needed, no rate limits  
**Cons:** Only accessible locally

### Setup:

```bash
# Start local registry
docker run -d -p 5000:5000 --restart=always --name registry registry:2

# Or use the setup script
chmod +x local-registry-setup.sh
./local-registry-setup.sh
```

### Build and Push:

```bash
# Build image
docker build -t simple-go-http-server .

# Tag for local registry
docker tag simple-go-http-server localhost:5000/simple-go-http-server

# Push to local registry
docker push localhost:5000/simple-go-http-server

# Or use the script
chmod +x push-to-local-registry.sh
./push-to-local-registry.sh
```

### Use in Kubernetes:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-go-http-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: simple-go-http-server
  template:
    metadata:
      labels:
        app: simple-go-http-server
    spec:
      containers:
      - name: server
        image: localhost:5000/simple-go-http-server
        imagePullPolicy: Always
        ports:
        - containerPort: 8090
```

---

## Option 2: Docker Hub (Free Public/Private Repos)

**Pros:** Free, accessible anywhere, 1 private repo free  
**Cons:** Rate limits on pulls, requires account

### Setup:

```bash
# Login to Docker Hub
docker login

# Tag with your Docker Hub username
docker tag simple-go-http-server YOUR_USERNAME/simple-go-http-server

# Push
docker push YOUR_USERNAME/simple-go-http-server
```

### Use in Kubernetes:

```yaml
image: YOUR_USERNAME/simple-go-http-server
```

---

## Option 3: GitHub Container Registry (GHCR) - FREE

**Pros:** Unlimited free public/private repos, integrates with GitHub  
**Cons:** Requires GitHub account

### Setup:

```bash
# Create a GitHub Personal Access Token (PAT) with packages:write permission
# Go to: Settings > Developer settings > Personal access tokens

# Login to GHCR
echo YOUR_GITHUB_PAT | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# Tag image
docker tag simple-go-http-server ghcr.io/YOUR_GITHUB_USERNAME/simple-go-http-server

# Push
docker push ghcr.io/YOUR_GITHUB_USERNAME/simple-go-http-server
```

### Use in Kubernetes:

```yaml
image: ghcr.io/YOUR_GITHUB_USERNAME/simple-go-http-server
```

If private, create a secret:

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_PAT
```

And reference it in your deployment:

```yaml
spec:
  imagePullSecrets:
  - name: ghcr-secret
  containers:
  - name: server
    image: ghcr.io/YOUR_GITHUB_USERNAME/simple-go-http-server
```

---

## Option 4: Colima Built-in (No Registry Needed!)

**Pros:** Simplest, no registry needed  
**Cons:** Only works with images built in Colima

If you built your image with Colima's Docker, it's **already available** to your Kubernetes cluster!

```bash
# Build image (in Colima)
docker build -t simple-go-http-server .

# Use directly in Kubernetes (no push needed!)
# Just set imagePullPolicy to Never or IfNotPresent
```

### Use in Kubernetes:

```yaml
spec:
  containers:
  - name: server
    image: simple-go-http-server
    imagePullPolicy: Never  # or IfNotPresent
    ports:
    - containerPort: 8090
```

---

## Quick Comparison

| Option | Cost | Setup | Access | Best For |
|--------|------|-------|--------|----------|
| **Local Registry** | Free | Easy | Local only | Local dev/testing |
| **Docker Hub** | Free* | Easy | Anywhere | Public images |
| **GitHub (GHCR)** | Free | Medium | Anywhere | Private/public repos |
| **Colima Direct** | Free | None | Local only | Quick local testing |

\* Free tier with limits

---

## Recommendation

**For local development with Colima:**
1. Start with **Option 4 (Colima Direct)** - easiest, no setup
2. If that doesn't work, use **Option 1 (Local Registry)** - still local, works reliably
3. For sharing or CI/CD, use **Option 3 (GHCR)** - unlimited free repos

---

## Troubleshooting

### Local registry not accessible from k8s?

If using Colima, make sure both Docker and Kubernetes are using the same network:

```bash
# Check Colima status
colima status

# Restart Colima with Kubernetes enabled
colima start --kubernetes
```

### "x509: certificate signed by unknown authority" error?

This happens with insecure registries. Add to Colima:

```bash
colima start --kubernetes --insecure-registry localhost:5000
```

Or add to your deployment:

```yaml
imagePullPolicy: IfNotPresent
```

