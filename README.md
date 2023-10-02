# function-add-k8s-labels-annotations

A [Crossplane](https://crossplane.io) Composition Function that
add Kubernetes Labels and Annotations to all Managed Resources
in a Composition.

Please note this Function is compatible with Crossplane 1.14 and newer.

## Installing a test build of Crossplane

Until the release of 1.14, a test build can be installed from
the master branch. The newest build tags can be seen at <https://hub.docker.com/r/crossplane/crossplane/tags>

```console
helm repo add crossplane-master https://charts.crossplane.io/master --force-update

helm upgrade --install crossplane --namespace crossplane-system crossplane-master/crossplane --devel --set "args={--debug,--enable-usages}"
```

## Running this function in a Composition

Install the functions by applying the manifests in [manifests/function.yaml](manifests/function.yaml):

```console
kubectl apply -f manifests/function.yaml
```

Ensure the Functions are installed:

```console
kubectl get Function 
```

Install the AWS Provider and Composition:

- `kubectl apply -f manifests/aws-vpc-composition/`
- `kubectl apply -f manifests/aws-provider.yaml`

Set up the `ProviderConfig` to authenticate to AWS. It should point to a
Kubernetes secret that contains AWS authentication information.

- `kubectl apply -f manifests/aws-providerconfig-default.yaml`

## Creating a Network Claim

The Example Claim creates a VPC and InternetGateway. After the
composition pipelines are complete, each resource should have
the labels and annotations in the Composition pipeline input added.

`kubectl apply -f manifests/examples/network-claim.yaml`

## Running This Function In a Composition

Once the function is installed into a cluster, it can be used
in a composition by defining the following step with an `input`
containing the labels and annotations to be added.

This pipeline step should be run after all Desired Resources have been
defined.

```yaml
  - step: add-k8s-labels-annotations
    functionRef:
      name: function-add-k8s-labels-annotations
    input:
      apiVersion: meta.borrelli.fn.crossplane.io/v1beta1
      kind: Input
      labels:
        xfn-provisioned-by: crossplane
        xfn-owner: platform-engineering
      annotations:
        added-by-xfn: "true"
```
