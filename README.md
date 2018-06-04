# tg-security-hackstop
Zuhlke UK 2018 Camp project


AWS configuration:

* VPC configuration `vpc-91d1bbfa` with 3 subnet:
    1. Public subnet for attacker: `subnet-65037428`
    1. Public subnet for splunk: `subnet-04d4e26f`
    1. Private subnet for hacker: `subnet-04d4e26f`
* Server configured:
    * NAT server
    * Jump Server 
    * Splunk 
    * Kubernetes cluster
* Kubernetes cluster: