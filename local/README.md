## Security Topic Team

Pen-testing detection lab.

⚠️ Under construction ⚠️

### Set up instructions

To set up the lab, run:

```bash
./scripts/setup.sh
```

##### Configuration options

Some default settings may be overridden via shell variables.

`MINIKUBE_PROFILE`: the Minikube profile name.
`MINIKUBE_VM_DRIVER`: the Minikube VM driver.

```bash
# Example
MINIKUBE_VM_DRIVER=hyperkit MINIKUBE_PROFILE=example-profile ./scripts/setup.sh
```

Note:
- changing `MINIKUBE_VM_DRIVER` may cause issues if Kali Linux is not running in the same Hypervisor.

  You will need to use a NATPF set-up or a tunnelling solution to allow Kali to access the Minikube VM.

##### Kali Linux

At time of writing, the default credentials are user `vagrant` and password `changeme`.

To access the `root` user, use `sudo`. 

You can also use `vagrant ssh` and change the password of the `vagrant` user to a desired value.

##### Vagrant and VMWare Fusion

This requires a commercial addon.

Alternatively, you can download the .box file from:

- https://app.vagrantup.com/csi/boxes/kali_rolling/versions/2018.2.2/providers/vmware_desktop.box

Extract the contents and manually install.

Commands to investigate:

```bash
vagrant box add kali-linux file:///d:/path/to/csi_kali/vmware_desktop.box
```

### NATPF and SSH Tunnels

You need to allow Kali to connect to the Minikube VM. This is particularly important when they are not running under the same Hypervisor.


##### SSH tunnel

```bash
ssh -i ~/.minikube/machines/<profile_name>/id_rsa -L 30100:localhost:30100 -N docker@`minikube --profile=<profile_name> ip`
vagrant ssh -- -R 30100:localhost:30100 -N
```

##### Utility `pfctl` (Mac OSX)

TBC

##### VMWare Fusion NATPF

Edit `/Library/Preferences/VMware\ Fusion/vmnet???/nat.conf`

Where `vmnet???` can be determined using `ifconfig` and locating the IP address of the Fusion VM.

Refer to the bottom of `nat.conf` for examples of NATPF (`incomingtcp` / `incomingudp`)

Run:

```bash
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```

More information:

- http://networkinferno.net/port-forwarding-on-vmware-fusion

##### VirtualBox Fusion NATPF

`VBoxManage`

TBC

### Kali Linux

Useful reference:

- https://www.kali.org/news/kali-linux-metapackages/
- https://tools.kali.org/tools-listing

### Splunk Enterprise

Register for a trial at:

- https://www.splunk.com/en_us/download/splunk-enterprise/thank-you-enterprise.html

```bash
wget -O splunk-7.1.1-8f0ead9ec3db-linux-2.6-amd64.deb 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.1.1&product=splunk&filename=splunk-7.1.1-8f0ead9ec3db-linux-2.6-amd64.deb&wget=true'
```

Other option, Splunk Enterprise Free (for docker):

- https://hub.docker.com/r/splunk/splunk/
- https://store.docker.com/images/splunk-enterprise-free-for-docker

### Splunk Enterprise Security

Trial (Cloud):

- https://www.splunk.com/page/sign_up/es_sandbox?redirecturl=%2Fgetsplunk%2Fes_sandbox

Community edition:

- https://www.phantom.us/download/
