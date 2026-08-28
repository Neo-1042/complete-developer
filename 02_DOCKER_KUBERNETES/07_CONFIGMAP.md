# Centralized Configuration with configmap

```bash
kubectl create configmap currency-conversion-service --from-literal=CURRENCY_EXCHANGE_URI=http://currency-exchange

kubectl get configmap
# Generate a YAML file to save the declaration of this configmap
kubectl get configmap currency-conversion -o yaml > configmap.yaml
```

Next, clean up the configmap.yaml file:
```yaml
apiVersion: v1
data:
  CURRENCY_EXCHANGE_URI: http://currency-exchange
kind: ConfigMap
metadata:
  name: currency-conversion
  namespace: default
```

Backup your current `deployment.yaml` and then merge (add)
`configmap.yaml` into `deployment.yaml` separating sections
using `---`. Don't forget to comment out the original `env`
section and then add:
```yaml
    [...]
    name: mmv2-currency-conversion-service
    envFrom:
      - configMapRef:
        name: currency-conversion
```

Apply all changes:

```bash
kubectl apply -f deployment.yaml

kubectl get pods
kubectl logs -f currency-conversion-[POD_ID]
```