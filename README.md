# vagrant-podman_v4
Podman v4 test environment provisioner using Vagrant (libvirt) and SaltStack 

On Rocky Linux 8.5

```
dnf install -y vagrant \
    qemu-kvm libvirt virt-install
```

On Ubuntu 20.04

```
apt install -y vagrant \
    qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils \
    virtinst virt-manager libguestfs-tools
```

Install plugin

```
vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-reload
```

Provision

```
git clone git@github.com:panda1100/vagrant-podman_v4.git
cd vagrant-podman_v4
vagrant up
vagrant ssh
```

Verify

```
[vagrant@fedora ~]$ podman --version
podman version 4.0.0-dev
```

