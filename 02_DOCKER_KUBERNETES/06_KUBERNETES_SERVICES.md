# Kubernetes Service

- Each Pod has its own (ephemeral) IP address.
How do you ensure that external users are not impacted when:
    - A pod **fails** and **gets replaced** by Replica Set.
    - A new release happens and all existing pods of the old
    release are replaced.

This is where we create a **SERVICE**:
```bash
kubectl expose deployment name --type=LoadBalancer --port=80
```

## Three Types of Services

1. **ClusterIP** ---> Exposes the service on a cluster-internal
IP.  
<u>Use Case</u>: you want your microservice to be available only
inside the cluster (intra cluster communication).

2. **LoadBalancer** ---> Exposes the service externally using
a cloud provider's load balancer.  
<u>Use Case</u>: you want to create individual Load Balancers
for each microservice. \*You don't want to have too many
load balancers\*.

3. **NodePort** ---> Exposes the service on each node's IP
at a static port (the `NodePort`).  
<u>Use Case</u>: you do NOT want to create an external load
balancer for each microservice. You can create one 
**Ingress component** to load balance multiple microservices.

Google Cloud Platform ---> _Services & Ingress_.

# Command-Line Tools to Deploy your App

## `gcloud` Installation

1. `gcloud` ---> CLI to Google Cloud.
2. `kubectl` ---> CLI to Kubernetes.

```bash
curl https://sdk.cloud.google.com | bash
# Restart your shell
exec -l $SHELL

gcloud auth login
# START GCLOUD
gcloud init
```

## `kubectl` Installation

```bash
# If homebrew is installed, then:
brew install kubectl

kubectl version
```