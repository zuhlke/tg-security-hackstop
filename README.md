# Set up instructions

Under construction...

## Splunk Forwarder

```bash
cd SplunkForwarder
docker build -t splunk_fwdr .
docker run -it splunk_fwdr:latest
```

## Minikube

```bash
minikube start -memory 8192 -cpus 4 --vm-driver hyperkit

helm install -f WordPress/values-stable-wordpress-topicteam.yaml \
     stable/wordpress \
     --set-string wordpressPassword=... \
     --set-string mariadbRootPassword=... \
     --set-string mariadbPassword=...

ssh -i ~/.minikube/machines/minikube/id_rsa -L 30100:localhost:30100 -N docker@`minikube ip`
```

### Alternative options to SSH tunnelling:

#### Utility `pfctl` (Mac OSX)

TBC

#### VMWare Fusion NATPF

Edit `/Library/Preferences/VMware\ Fusion/vmnet???/nat.conf`

Where `vmnet???` can be determined using `ifconfig` and locating the IP address of the Fusion VM.

Refer to the bottom of `nat.conf` for examples of NATPF (`incomingtcp` / `incomingudp`)

Run:

```bash
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```

More information:

http://networkinferno.net/port-forwarding-on-vmware-fusion

## Install Kali in a VM (Fusion, VirtualBox, etc)

Choose at least 2 GB RAM and sufficient disk space (20 GB recommended).

When Kali is running, open a shell in Kali and type

```bash
ssh -L 30100:localhost:30100 -N <your_user_id>@<kali_macos_gateway_ip>
```
