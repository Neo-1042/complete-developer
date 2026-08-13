# Kubernetes Pods

- A Kubernetes POD is the smallest deployable unit in Kubernetes.
- A Pod is comprised of one or more containers. However,
most pods will contain only one container.
- Each pod is assigned an ephemeral IP address.

```bash
# Google Cloud Shell
kubectl get pods
kubectl get deployment -o wide
```

- All containers in the same pod share: network, storage,
IP address, ports and volumes (shared persistent disk).
- POD STATUSES:
    - running
    - pending
    - succeeded
    - failed
    - unknown