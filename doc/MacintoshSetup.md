# Macintosh Setup

## Install all the tools
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install wget
brew cask install virtualbox
brew cask install vagrant
brew cask install vagrant-manager
brew install docker docker-compose docker-machine xhyve docker-machine-driver-xhyve
sudo chown root:wheel /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.26.1/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
minikube start
brew install kubectl
brew install kops
brew install kubernetes-helm
brew install terraform
brew install awscli
brew install awsebcli
eval $(minikube docker-env)
docker ps
minikube dashboard
```
## AWS console

* https://zuhlke-engineering-ltd.signin.aws.amazon.com/console
* Username: <your 3- or 4-letter Zuhlke short code>
* Password: ********

Create new IAM access key:

* Access Key ID (example): ****A62A
* Secret Key (example): ****AHb4

The following commands were needed only once:
```
mkdir -p ~/.ssh
aws ec2 create-key-pair --key-name hackstop --query 'KeyMaterial' --output text > ~/.ssh/hackstop.pem
chmod 400 ~/.ssh/hackstop.pem
ssh-keygen -y -f ~/.ssh/hackstop.pem >  ~/.ssh/hackstop.pub
zip -9v ~/Downloads/hackstop_keypair.zip ~/.ssh/hackstop.*
```
Distribute the key pair to all project members.
## AWS configuration
```
aws configure
  Access Key ID: ****A62A
  Secret Access Key: ****AHb4
  Default region name: eu-central-1 // Frankfurt
  Default output format: json
```
## DNS configuration
The following commands were only needed once:
```
aws route53 create-hosted-zone --name hackstop.iotbox.online --caller-reference 1
```

* open https://console.aws.amazon.com/route53/home?region=eu-central-1#resource-record-sets:Z1R2YXDUHT3YAU
  * Add CNAME www.hackstop.iotbox.online —> hackstop.iotbox.online
  * Select NS records
  * Set TTL=1 day
  * Copy the four NS server names one at a time
* open https://dns.he.net/index.cgi?hosted_dns_zoneid=628448&menu=edit_zone&hosted_dns_editzone#
  * Add the four NS records for subdomain name hackstop.iotbox.online
  * Copy NS server names from AWS console as above
## S3 configuration
The following command was needed only once:
```
aws s3 mb s3://clusters.hackstop.iotbox.online
```
## Profile Configuration
If you don't yet have the project key pair installed, download it into your Downloads folder and run the following:
```
cd ~
unzip hackstop_keypair.zip
```
Add the following to your bash profile:
```
export KOPS_STATE_STORE=s3://clusters.hackstop.iotbox.online
kops create secret --name frontoffice.hackstop.iotbox.online sshpublickey admin -i ~/.ssh/hackstop.pub
```
## KOPS configuration
```
kops create cluster --zones=eu-central-1a frontoffice.hackstop.iotbox.online
kops get cluster
kops edit cluster frontoffice.hackstop.iotbox.online
kops edit ig --name=frontoffice.hackstop.iotbox.online nodes
kops edit ig --name=frontoffice.hackstop.iotbox.online master-eu-central-1a
  In both cases, change machine type to t2.small and add the following after nodeLabels:
  cloudLabels:
    Project: I15000_CU_DEV
    Description: Hackstop project for June 2018 Zuhlke days
    Component: Kubernetes master for frontoffice.hackstop.iotbox.online
  (In the case of nodes, substitute “cluster node” for “master”)
export KOPS_STATE_STORE=s3://clusters.hackstop.iotbox.online
kops create secret --name frontoffice.hackstop.iotbox.online sshpublickey admin -i ~/.ssh/hackstop.pub
kops update cluster frontoffice.hackstop.iotbox.online
  (Review output)
kops update cluster frontoffice.hackstop.iotbox.online --yes
  (Wait for DNS entries to propagate)
kops validate cluster
kubectl get nodes --show-labels
ssh -i ~/.ssh/hackstop.pem admin@api.frontoffice.hackstop.iotbox.online
exit
```
# To Shut Down and Delete Instances
```
kops delete cluster frontoffice.hackstop.iotbox.online --yes
```