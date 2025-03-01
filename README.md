# OpenTelemetry Traces with Grafana Tempo

## Table of contents

* [Introduction](#introduction)
* [Requirements](#requirements)
* [Terraform](#terraform)
* [Helm](#helm)
* [Grafana Tempo](#grafana-tempo)
* [Grafana](#grafana)
* [Test Application](#test-application)

## Introduction

High level design of the solution: a Python application, instrumented with the OpenTelemetry library, sends the telemetry data to OpenTelemetry Collector configured with the OTLP receiver. OpenTelemetry Collector dispatches the traces to Grafana Tempo using the OTLP receiver. Grafana Tempo stores the traces in one Azure Storage Account. A Tempo data source can be created in Grafana to connect to Grafana Tempo and visualise the traces.

This project consists of the following resources:

1. Azure Kubernetes Cluster
2. Azure Application Gateway
3. Azure Storage Account
4. User Managed Identity
5. OpenTelemetry Collector Helm Chart
6. Grafana Tempo Helm Chart
7. Grafana Helm Chart

## Requirements

- Terraform
- Kubectl
- Helm Chart
- Helmfile

## Terraform

### Configuration

- Assign the RBAC roles "Contributor", "User Access Administrator" to the User account on the Subscription level.
- Create the file `terraform.tfvars` with the values for the following Terraform variables:

```sh
location="<azure_region>" # e.g. "westeurope"
location_abbreviation="<azure_region_abbreviation>" # e.g. "weu"
environment="<environment_name>" # e.g. "test"
workload_name="<workload_name>"
allowed_public_ip_address_ranges=[<list_of_allowed_ip_address_ranges>] # Public IP Address ranges allowed to access the Azure resources e.g. "1.2.3.4/32"
allowed_public_ip_addresses=<[<list_of_allowed_ip_addresses>] # Public IP Addresses allowed to access the Azure resources  e.g. "1.2.3.4"
```

Before proceeding with the next sections, open a terminal and login in Azure with Azure CLI using the User account.

### Terraform Project Initialization

```sh
terraform init -reconfigure
```

### Verify the Updates in the Terraform Code

```sh
terraform plan
```

### Apply the Updates from the Terraform Code

```sh
terraform apply -auto-approve
```

Configure the Application Gateway Ingress Controller in `modules/aks/main.tf` after the provisioning of both the Application Gateway and the AKS cluster.

After the configuration of the Application Gateway Ingress Controller, assign the RBAC roles "Contributor" and "Network Contributor" 
to the Managed Identity `ingressapplicationgateway-aks-<environment>-<location_abbreviation>-001` on the Resource Group.

### Format Terraform Code

```sh
find . -not -path "*/.terraform/*" -type f -name '*.tf' -print | uniq | xargs -n1 terraform fmt
```

## Helm

### Configure Tempo Distributed

Configure the service account parameters in the Tempo Distributed Helm Chart values file `helm/values_grafana_tempo_distributed.yaml`:

```sh
serviceAccount:
  annotations:
    azure.workload.identity/client-id: "<user_managed_identity_client_id>"
    azure.workload.identity/tenant-id: "<azure_tenant_id>"
```

where `<user_managed_identity_client_id>` corresponds to the Client ID of the User Managed Identity `id-tempo-<environment>-<location_abbreviation>-001`, 
and `<azure_tenant_id>` corresponds to the Azure Tenant ID.

Configure the storage backend parameters in the Tempo Distributed Helm Chart values file `helm/values_grafana_tempo_distributed.yaml`:

```sh
storage:
  trace:
    backend: azure
    azure:
      container_name: "traces"
      storage_account_name: "<storage_account_name>"
      use_federated_token: true
```

where `<storage_account_name>` corresponds to the name of the Azure Storage Account.

### Create Kubernetes Resources

```sh
cd helm
helmfile apply
```

### Check Kubernetes Resources

```sh
kubectl get all,cm,secret,ing -n tracing
```

### Delete Kubernetes Resources

```sh
cd helm
helmfile delete
```

## Grafana Tempo

### Verify the Members List

```sh
kubectl port-forward svc/tempo-distributed-distributor 3100:3100 --namespace tracing
```

Access to the page: http://localhost:3100/memberlist

## Grafana

### Access Grafana

Access Grafana from the URL:

```sh
http://<application_gateway_public_ip>
```

### Login Grafana

Retrieve the Grafana credentials:

```sh
kubectl get secret grafana -n tracing -o json | jq '.data | map_values(@base64d)'
```

### Grafana Tempo Data Source

Use the following connection URL in the Tempo Data Source:

```sh
http://tempo-distributed-gateway.tracing.svc.cluster.local
```

## Test Application

[test-application/README.md](https://github.com/sitMCella/opentelemetry-traces-grafana-tempo/tree/main/test-application/README.md)
