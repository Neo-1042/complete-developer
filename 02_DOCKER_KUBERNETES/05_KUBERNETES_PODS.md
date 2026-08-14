# Kubernetes Pods

- A Kubernetes POD is the smallest deployable unit in Kubernetes.
- A Pod is comprised of one or more containers. However,
most pods will contain only one container.
- Each pod is assigned an ephemeral IP address.

```bash
# Google Cloud Shell
kubectl get pods -o wide
# Ephemeral IP addresses are assigned to pods
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

# Deployment vs Replica Set

A deployment is created for each microservice: 

`kubectl create deployment m1 --image=m1:v1`

A single deployment represents a microservice, with all of its
releases (versions).
A deployment must manage new releases ensuring **zero downtime**:

```bash
# Update the image of the container to version 0.0.2.RELEASE:
kubectl set image deployment hello-world-rest-api hello-world-rest-api=neo_1042/hello-world-rest-api:0.0.2.RELEASE

kubectl get services
```

## Replica Sets

A **Replica Set** ensures that a specific number of pods are
running for a specific microservice version.
A replica set represents a specific deployment version (with
its specific pods and containers).

```bash
# Here you can check which replicasets are not active
kubectl get replicasets
kubectl get po
```