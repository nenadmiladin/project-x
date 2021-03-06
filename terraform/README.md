# Azure Kubernetes Service (AKS) with Terraform
:boom:
This folder contains HashiCorp Terraform configuration required to create a Azure AKS cluster.

## Prerequisites

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) installed.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed.
* HashiCorp [Terraform](https://terraform.io/downloads.html) installed.
* Terraform version: `0.12.x`
* [Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html) version: `1.36.1`

## Tutorial

* Generate Azure client id and secret.

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

Expected output:

```bash
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "azure-cli-2017-06-05-10-41-15",
  "name": "http://azure-cli-2017-06-05-10-41-15",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}
```

`appId` - Client id.
`password` - Client secret.
`tenant` - Tenant id.

Export environment variables to configure the [Azure](https://www.terraform.io/docs/providers/azurerm/index.html) Terraform provider.

```bash
export ARM_SUBSCRIPTION_ID="YOUR_SUBSCRIPTION_ID"
export ARM_TENANT_ID="TENANT_ID"
export ARM_CLIENT_ID="CLIENT_ID"
export ARM_CLIENT_SECRET="CLIENT_SECRET"
export TF_VAR_client_id=${ARM_CLIENT_ID}
export TF_VAR_client_secret=${ARM_CLIENT_SECRET}
```

* Run Terraform init and plan.

```bash
cd kubernetes-cluster/
```

```bash
terraform init
```

```bash

Initializing the backend...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.null: version = "~> 2.1"
* provider.tls: version = "~> 2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```bash
terraform plan
```

```bash
terraform apply
```

*Note: Creating an Azure AKS cluster can take up to 15 minutes.*

* Configure kubeconfig

Instructions can be obtained by running the following command

```bash
terraform output configure

Run the following commands to configure kubernetes client:

$ terraform output kube_config > ~/.kube/config
$ export KUBECONFIG=~/.kube/config
```

Save kubernetes config file to `~/.kube/config`

```bash
terraform output kube_config > ~/.kube/config
```

Set `KUBECONFIG` environment variable to the kubernetes config file

```bash
export KUBECONFIG=~/.kube/config
```

* Test configuration.

```bash
kubectl get nodes
```

EXAMPLE:
```bash
nenad@Azure:~$ kubectl get all
NAME                                   READY   STATUS    RESTARTS   AGE
pod/azure-vote-back-7dbcd6c889-qz75l   1/1     Running   0          28h
pod/azure-vote-front-d9566c557-qwpk4   1/1     Running   0          27h

NAME                       TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
service/azure-vote-back    ClusterIP      10.0.178.17   <none>          6379/TCP       28h
service/azure-vote-front   LoadBalancer   10.0.20.115   52.190.44.102   80:32218/TCP   28h
service/kubernetes         ClusterIP      10.0.0.1      <none>          443/TCP        3d3h

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/azure-vote-back    1/1     1            1           28h
deployment.apps/azure-vote-front   1/1     1            1           28h

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/azure-vote-back-7dbcd6c889    1         1         1       28h
replicaset.apps/azure-vote-front-657d4d5c97   0         0         0       27h
replicaset.apps/azure-vote-front-67977fb785   0         0         0       27h
replicaset.apps/azure-vote-front-68cd455ffd   0         0         0       27h
replicaset.apps/azure-vote-front-d9566c557    1         1         1       28h
```
