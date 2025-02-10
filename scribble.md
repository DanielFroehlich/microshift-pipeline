
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

# Install and run pipelines

## install
`oc apply -f pipeline.yaml`


## run:
```
tkn pipeline start build-image \
    --prefix-name prefixName42 \
    -w name=shared-workspace,claimName=pipeline-workspace \
    -p git-url=https://github.com/DanielFroehlich/microshift-pipeline.git  \
    -p IMAGE=quay.coe.muc.redhat.com/dfroehli/test \
    --use-param-defaults
``
