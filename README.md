# Trivia App

## Table of Content

- [Trivia App](#trivia-app)
  - [Table of Content](#table-of-content)
  - [Prerequisites](#prerequisites)
  - [Build and Publish Docker Image](#build-and-publish-docker-image)
  - [Test Helm Chart](#test-helm-chart)
  - [Run Helm Chart](#run-helm-chart)

## Prerequisites

Run `make prerequisites` to check whether your system already have required programs:
- [Kubernetes](https://kubernetes.io)
- [Docker](https://www.docker.com/)
- [Helm](https://helm.sh/)
- [dgoss](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss)
- [Make](https://www.gnu.org/software/make/)


## Build and Publish Docker Images

Current `Makefile` will build and publish both backend and frontend using single job. Example:
executing `make build-images` will build both backend and frontend sequentially.

1. Ensure you logged in to Docker registry by execute `make config username=<docker-username>`
2. You could run `make docker-images username=<docker-username>` to run complete docker images "pipeline"
contains `build` and `publish` jobs.
3. Execute `make build-images username=<docker-username>` to build and test docker images
4. Execute `make publish-images username=<docker-username>` to push the docker images

## Test Helm Chart

Assuming kubernetes cluster already in place, you can test or install helm chart.
Please note, `trivia-helm/values.yaml` might need to changed accordingly, 
i.e: using ingress should update `frontend.ingress.enabled`, and its annotation.

### Dry Run Helm Chart

You could check and validate the helm chart manifests by using dry-run like below:
```bash
make helm-dry-run environment=test
```

```yaml
==> Linting trivia-helm/
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
NAME: trivia-helm-1593837499
LAST DEPLOYED: Sat Jul  4 11:38:19 2020
NAMESPACE: default
STATUS: pending-install
REVISION: 1
TEST SUITE: None
HOOKS:
MANIFEST:
---
# Source: trivia-helm/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: trivia-helm-1593837499
  labels:
    app: trivia-helm-1593837499
---
# Source: trivia-helm/templates/backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: trivia-helm-1593837499-backend
  labels:
    name: trivia-helm-1593837499-backend
spec:
  type: ClusterIP
  ports:
    - port: 8081
      targetPort: http
      protocol: TCP
  selector:
    app: trivia-helm-1593837499-backend
---
# Source: trivia-helm/templates/frontend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: trivia-helm-1593837499-frontend
  labels:
    name: trivia-helm-1593837499-frontend
spec:
  type: ClusterIP
  ports:
    - port: 3000
      targetPort: http
      protocol: TCP
      name: http
  selector:
    name: trivia-helm-1593837499-frontend
---
# Source: trivia-helm/templates/backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: trivia-helm-1593837499-backend
  labels:
    app: trivia-helm-1593837499-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: trivia-helm-1593837499-backend
  template:
    metadata:
      labels:
        app: trivia-helm-1593837499-backend
    spec:
      serviceAccountName: trivia-helm-1593837499
      containers:
        - name: trivia-helm
          image: "rizkidoank/trivia-backend:0.1.0"
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8081
              protocol: TCP
              name: http
          resources:
            {}
---
# Source: trivia-helm/templates/frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: trivia-helm-1593837499-frontend
  labels:
    app: trivia-helm-1593837499-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: trivia-helm-1593837499-frontend
  template:
    metadata:
      labels:
        app: trivia-helm-1593837499-frontend
    spec:
      serviceAccountName: trivia-helm-1593837499
      containers:
        - name: trivia-helm
          image: "rizkidoank/trivia-frontend:0.1.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 3000
              protocol: TCP
          env:
          - name: BACKEND_URL
            value: "http://trivia-helm-1593837499-backend"
          - name: BACKEND_PORT
            value: "8081"
          resources:
            {}
```

```bash
make helm-dry-run environment=production
```

```yaml
==> Linting trivia-helm/
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
NAME: trivia-helm-1593837592
LAST DEPLOYED: Sat Jul  4 11:39:52 2020
NAMESPACE: default
STATUS: pending-install
REVISION: 1
TEST SUITE: None
HOOKS:
MANIFEST:
---
# Source: trivia-helm/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: trivia-helm-1593837592
  labels:
    app: trivia-helm-1593837592
---
# Source: trivia-helm/templates/backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: trivia-helm-1593837592-backend
  labels:
    name: trivia-helm-1593837592-backend
spec:
  type: ClusterIP
  ports:
    - port: 8081
      targetPort: http
      protocol: TCP
  selector:
    app: trivia-helm-1593837592-backend
---
# Source: trivia-helm/templates/frontend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: trivia-helm-1593837592-frontend
  labels:
    name: trivia-helm-1593837592-frontend
spec:
  type: ClusterIP
  ports:
    - port: 3000
      targetPort: http
      protocol: TCP
      name: http
  selector:
    name: trivia-helm-1593837592-frontend
---
# Source: trivia-helm/templates/backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: trivia-helm-1593837592-backend
  labels:
    app: trivia-helm-1593837592-backend
spec:
  selector:
    matchLabels:
      app: trivia-helm-1593837592-backend
  template:
    metadata:
      labels:
        app: trivia-helm-1593837592-backend
    spec:
      serviceAccountName: trivia-helm-1593837592
      containers:
        - name: trivia-helm
          image: "rizkidoank/trivia-backend:0.1.0"
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8081
              protocol: TCP
              name: http
          resources:
            {}
---
# Source: trivia-helm/templates/frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: trivia-helm-1593837592-frontend
  labels:
    app: trivia-helm-1593837592-frontend
spec:
  selector:
    matchLabels:
      app: trivia-helm-1593837592-frontend
  template:
    metadata:
      labels:
        app: trivia-helm-1593837592-frontend
    spec:
      serviceAccountName: trivia-helm-1593837592
      containers:
        - name: trivia-helm
          image: "rizkidoank/trivia-frontend:0.1.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 3000
              protocol: TCP
          env:
          - name: BACKEND_URL
            value: "http://trivia-helm-1593837592-backend"
          - name: BACKEND_PORT
            value: "8081"
          resources:
            {}
---
# Source: trivia-helm/templates/backend-hpa.yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: trivia-helm-1593837592-backend
  labels:
    app: trivia-helm-1593837592-backend
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: trivia-helm-1593837592-backend
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: 80
---
# Source: trivia-helm/templates/frontend-hpa.yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: trivia-helm-1593837592-frontend
  labels:
    app: trivia-helm-1593837592-frontend
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: trivia-helm-1593837592-frontend
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: 80
```

## Installing Helm Chart

```bash
make helm-install name=<release-name> environment=<environment>
```

## Validate Trivia App

1. Ensure docker images already built and pushed.
2. Create new helm release by using the helm chart, ensure you already update `values.yaml` accordingly
3. Check whether the deployment and pods running properly. `kubectl get deployment` or `kubectl get pods`
```bash
rizki@DESKTOP-36GQJ0B:~/develop/trivia-assessment$ kubectl get pods
NAME                                               READY   STATUS    RESTARTS   AGE
sample-prod-trivia-helm-backend-5d56cdf857-m2v6r   1/1     Running   0          4s
sample-prod-trivia-helm-frontend-99767fbc9-268zs   1/1     Running   0          4s
rizki@DESKTOP-36GQJ0B:~/develop/trivia-assessment$ kubectl get deployment
NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
sample-prod-trivia-helm-backend    1/1     1            1           15s
sample-prod-trivia-helm-frontend   1/1     1            1           15s
```
4. If you use `ClusterIP` (private), you could use port forward by running 
`kubectl port-forward deployment/<release-name>-trivia-helm-frontend :3000`. Then, open the URL provided by kubernetes.
5. To make it available public, you have options: use `LoadBalancer` service type on `frontend.service.type` then find your
public IP using `kubectl get service`
6. Another options, you could use `ingress` by change your `values.yaml` at `frontend.ingress.*`

NOTE: you need to have an ingress controller (nginx, traefik, etc) or support for load balancer on the cluster (use MetalLB or Cloud Provider).