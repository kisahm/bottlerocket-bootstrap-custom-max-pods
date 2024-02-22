# Custom image to manipulate Bottlerocket max pods count
The image include a customized `max-pod-calculation.sh` to support the correct calculation of max pods per node.

Additional options:
* `--custom-cni cilium` to enable the custom feature
* `--cilium-first-interface-index <number>` to calculate the correct amount of pods if `first-interface-index` > 0


All options:
```
usage: $0 <instance(s)> [options]
Calculates maxPods value to be used when starting up the kubelet.
-h,--help print this help.
--instance-type Specify the instance type to calculate max pods value.
--instance-type-from-imds Use this flag if the instance type should be fetched from IMDS.
--cni-version Specify the version of the CNI (example - 1.7.5).
--cni-custom-networking-enabled Use this flag to indicate if CNI custom networking mode has been enabled.
--cni-prefix-delegation-enabled Use this flag to indicate if CNI prefix delegation has been enabled.
--cni-max-eni specify how many ENIs should be used for prefix delegation. Defaults to using all ENIs per instance.
--show-max-allowed Use this flag to show max number of Pods allowed to run in Worker Node. Otherwise the script will show the recommended value
--custom-cni <cilium> Use this if you use other CNIs like Cilium
--cilium-first-interface-index <number>
```

## Usage

1. define your user data which include the options for max-pod-calculation.sh
```
echo export ADDITIONAL_OPTIONS=\"--custom-cni cilium --cilium-first-interface-index 1\"|base64
```

2. add the helper pod to your Bottlerocket config:
```
[settings.bootstrap-containers.max-pods-calculator]
source = "docker.io/kisahm/bottlerocket-bootstrap-max-pods:v0.2"
essential = false
mode = "always"
user-data = "<user data base64>"
```

NOTE: By using CAST AI, the definion should looks lik this:
```
settings.bootstrap-containers.max-pods-calculator.source = "docker.io/kisahm/bottlerocket-bootstrap-max-pods:v0.2"
settings.bootstrap-containers.max-pods-calculator.essential = false
settings.bootstrap-containers.max-pods-calculator.mode = "always"
settings.bootstrap-containers.max-pods-calculator.user-data = "ZXhwb3J0IEFERElUSU9OQUxfT1BUSU9OUz0iLS1jdXN0b20tY25pIGNpbGl1bSAtLWNpbGl1bS1maXJzdC1pbnRlcmZhY2UtaW5kZXggMSIK"
```

## Result
Check the max-pod value of your Kubernetes nodes. 

Example:
* Used instance: c7i.2xlarge
* Official max pods: 58 (see https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt)
* With `--cilium-first-interface-index 1`:
  * max pods: 44