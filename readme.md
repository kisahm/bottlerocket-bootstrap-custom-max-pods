# Custom image to manipulate Bottlerocket max pods count
The image include a customized `max-pod-calculation.sh` to support the correct calculation of max pods per node.

Additional options:
* `--custom-cni cilium` to enable the custom feature
* `--cilium-first-interface-index <number>` to calculate the correct amount of pods if `first-interface-index` > 0

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