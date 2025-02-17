
# Pre-Reqs
## OpenShift Cluster
* We are using stormshift OCP2!
```
% oc project
Using project "dfroehli-ushift-pipelines" on server "https://api.ocp2.stormshift.coe.muc.redhat.com:6443".
```

## Pipeline Operator
Make sure pipeline operator is installed
TODO: Automated that as stormshift feature

## Cluster Tasks
Ensure ClusterTasks buildah and git-clone are there:
```
% tkn tasks ls -n openshift-pipelines
NAME                      DESCRIPTION              AGE
buildah                   Buildah task builds...   4 days ago
buildah-1-17-0            Buildah task builds...   5 days ago
git-cli                   This task can be us...   4 days ago
git-cli-1-17-0            This task can be us...   5 days ago
git-clone                 This object represe...   4 days ago
git-clone-1-17-0          This object represe...   5 days ago
```

## Registry Repo and Robo-Account
We use https://quay.coe.muc.redhat.com/repository/dfroehli/test?tab=info in the following
Download the robo secret from quay and apply it
we use `coe-quay` as the name in the following.
We create it from the dockerconfig, as we have several differnt accounts to add, and that is more transparent:

```
oc delete secret/coe-quay; oc create secret docker-registry coe-quay --from-file=.dockerconfigjson=secret-coe-quay-cfg.json
```

## Entitlement
We need to do entiteld builds, as we need additonal packages from Red Hat repos.
See the docs on how to get the entitlement secret:
https://docs.openshift.com/pipelines/1.17/create/using-rh-entitlements-pipelines.html

```
oc get secret etc-pki-entitlement -n openshift-config-managed -o json | jq 'del(.metadata.resourceVersion)' | jq 'del(.metadata.creationTimestamp)' | jq 'del(.metadata.uid)' | jq 'del(.metadata.namespace)' | oc -n <pipeline_namespace> create -f -
```


```
oc create -f secret-redhat-entitlement.json
```


# Install and run pipelines

## install
`oc apply -f pipeline.yaml`


## run to build microshift bootc image:
```
tkn pipeline start build-image \
    --prefix-name ushift-bootc \
    --workspace name=shared,claimName=pipeline-workspace \
    --workspace name=registry,secret=coe-quay \
    --workspace name=rhel-entitlement,secret=etc-pki-entitlement \
    --param git-url=https://github.com/DanielFroehlich/microshift-bootc.git  \
    --param IMAGE=quay.coe.muc.redhat.com/shared/dfroehli/test \
    --use-param-defaults
```

## run to build tools image:
```
tkn pipeline start build-image \
    --prefix-name tools-image \
    --workspace name=shared,claimName=pipeline-workspace \
    --workspace name=registry,secret=coe-quay \
    --workspace name=rhel-entitlement,secret=etc-pki-entitlement \
    --param git-url=https://github.com/DanielFroehlich/tools-image.git  \
    --param IMAGE=quay.io/dfroehli/tools \
    --use-param-defaults
```

# Debug helpers

## Better understand a cluster task:
```
tkn tasks describe buildah -n openshift-pipelines
```

## Debug a failed task
One can actually "oc debug pod/...." into a failed task and look around, e.g. how the workspaces look like


# Path inside the build tasks
/workspace/dockerconfig
/workspace/dockerconfig/.dockerconfigjson

```
# ls  /tmp/entitlement/
entitlement-key.pem  entitlement.pem
```
