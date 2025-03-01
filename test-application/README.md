# OpenTelemetry Test Application

The following directory contains a simple application for sending traces to either 
OpenTelemetry Collector or Grafana Tempo using the OTLP protocol.

https://github.com/rutu-sh/otel-k8s-experiments/tree/main/common-applications/auto-instrumented/python/simple-fastapi-app

## Requirements

Deploy either OpenTelemetry Collector or Grafana Tempo in the Kubernetes cluster.

## Configuration

Configure the ConfigMap "single-app-single-collector" with the URL of the OTLP distributor.

### Grafana Tempo

Update the file "deployment.yaml" with the appropriate configuration.
In order to connect to OpenTelemetry Collector, use the following configuration:

```sh
OTEL_EXPORTER_OTLP_ENDPOINT: "http://opentelemetry-collector.tracing.svc.cluster.local:4317"
```

In order to connect to Grafana Tempo, use the following configuration:

```sh
OTEL_EXPORTER_OTLP_ENDPOINT: "http://tempo-distributed-distributor.tracing.svc.cluster.local:4317"
```

## Application Deployment

```sh
kubectl apply -f deployment.yaml
```

## Test Application

```sh
kubectl port-forward svc/single-app-single-collector 8000:8000 --namespace opentelemetry-demo
```

### Execute Test

```sh
./test.sh
```

### Example APIs

Create item:

```sh
curl -X POST -d '{"name": "item1", "price": 4.0}' -H "Content-Type: application/json" http://localhost:8000/rest/v1/item
```

Read item:

```sh
curl -X GET http://localhost:8000/rest/v1/item/item1
```
