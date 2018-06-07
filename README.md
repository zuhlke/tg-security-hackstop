## Security Topic Team

Pen-testing detection lab.

⚠️ Under construction ⚠️

#### Set up instructions

To set up the lab, run:

```bash
./scripts/setup.sh
```

###### Configuration options

To override the default Minikube VM driver the script uses, set variable `VM_DRIVER`:

```bash
VM_DRIVER=hyperkit ./scripts/setup.sh
```

###### Kali Linux

At time of writing, the default credentials are user `vagrant` and password `changeme`.

To access the `root` user, use `sudo`. 

You can also use `vagrant ssh` and change the password of the `vagrant` user to a desired value.

###### Vagrant and VMWare Fusion

This requires a commercial addon.

Alternatively, you can download the .box file from:

https://app.vagrantup.com/csi/boxes/kali_rolling/versions/2018.2.2/providers/vmware_desktop.box

Extract the contents and manually install.

Commands to investigate:

```bash
vagrant box add kali-linux file:///d:/path/to/csi_kali/vmware_desktop.box
```

#### Tunnels

```bash
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
