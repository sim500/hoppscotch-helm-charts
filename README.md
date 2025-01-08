# Digital Ocean Kubernetes Installation Guide

This comprehensive guide will help you install and configure the application on your Digital Ocean Kubernetes cluster.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Cluster Setup](#cluster-setup)
3. [Installation Steps](#installation-steps)
4. [Configuration](#configuration)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)
7. [Maintenance](#maintenance)

## Prerequisites

- Digital Ocean account with administrative access
- kubectl CLI tool installed locally
- Helm 3.x installed
- Digital Ocean CLI (doctl) installed
- Valid kubeconfig file from Digital Ocean

## Cluster Setup

### 1. Configure Cluster Access

Download and configure your kubeconfig file (this file is provided by Digital Ocean):

```bash
export KUBECONFIG=path/to/k8s-xxxx-xxxx-kubeconfig.yaml
kubectl get nodes    # Verify connectivity
```

### 2. Install NGINX Ingress Controller

This is required for first-time cluster setup:

*Note:* If ingress controller already exists you can skip this step.

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/do/deploy.yaml
```

Verify NGINX installation:

```bash
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

## Installation Steps

### 1. Add Helm Repository

```bash
helm repo add [repo-name] [repository-url]
helm repo update
```

### 2. Create Namespace

```bash
kubectl create namespace [your-namespace]

# Check current context
kubectl config get-contexts

# If context is not updated, update it using:
kubectl config use-context [your-context-name]

# Verify current context
kubectl config current-context

# Set namespace for current context
kubectl config set-context --current --namespace=[your-namespace]
```

### 3. Configure Values

Create a values configuration file with your settings:

```yaml
# Example configuration
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx

resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### 4. Install Helm Chart

```bash
helm install [release-name] [chart-name] \
  --namespace [your-namespace] \
  -f [path-to-values-file]
```

Example:

```bash
helm install my-release my-chart \
  --namespace my-namespace \
  -f ./values.yaml
```

## Configuration

### Essential Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress controller | `true` |
| `resources.requests.memory` | Memory request | `256Mi` |
| `resources.requests.cpu` | CPU request | `250m` |

## Verification

### 1. Check Deployment Status

```bash
kubectl get pods -n [your-namespace]
kubectl get services -n [your-namespace]
kubectl get ingress -n [your-namespace]
```

### 2. Validate Application Access

```bash
kubectl get ingress -n [your-namespace]  # Note the ADDRESS field
```

## Troubleshooting

### Common Issues

1. **Pods Not Starting**
   ```bash
   kubectl describe pod [pod-name] -n [your-namespace]
   kubectl logs [pod-name] -n [your-namespace]
   ```

2. **NGINX Issues**
   ```bash
   kubectl get pods -n ingress-nginx
   kubectl logs [nginx-pod-name] -n ingress-nginx
   ```

3. **Helm Chart Issues**
   ```bash
   helm status [release-name] -n [your-namespace]
   ```

## Maintenance

### Upgrading

```bash
helm repo update
helm upgrade [release-name] [chart-name] \
  --namespace [your-namespace] \
  -f [path-to-values-file]
```

### Rollback

```bash
helm rollback [release-name] [revision] -n [your-namespace]
```

### Uninstallation

```bash
helm uninstall [release-name] -n [your-namespace]
```

## Support

For additional support:
- Submit issues on our GitHub repository

## Security Considerations

- Always use unique credentials for production environments
- Regularly update your Helm charts and dependencies
- Monitor cluster resources and set appropriate resource limits
- Enable network policies as needed

## References

- [Digital Ocean Kubernetes Documentation](https://www.digitalocean.com/docs/kubernetes/)
- [Helm Documentation](https://helm.sh/docs/)
- [NGINX Ingress Controller Documentation](https://kubernetes.github.io/ingress-nginx/)

---

**Note:** Replace placeholders (marked with [square brackets]) with your actual values before using this guide.