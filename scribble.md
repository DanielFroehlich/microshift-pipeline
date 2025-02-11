
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
oc create secret docker-registry coe-quay --from-file=.dockerconfigjson=secret-coe-quay-cfg.json
```


# Install and run pipelines

## install
`oc apply -f pipeline.yaml`


## run:
```
tkn pipeline start build-image \
    --prefix-name test \
    --workspace name=shared,claimName=pipeline-workspace \
    --workspace name=registry,secret=coe-quay \
    --param git-url=https://github.com/DanielFroehlich/microshift-pipeline.git  \
    --param IMAGE=quay.coe.muc.redhat.com/shared/dfroehli/test \
    --use-param-defaults
```

# Debug helpers

## Better understand a cluster task:
```
tkn tasks describe buildah -n openshift-pipelines
```

## Debug a failed task
One can actually "oc debug pod/...." into a failed task and look around, e.g. how the workspaces look like
