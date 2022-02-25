# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "fedora/35-cloud-base"

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 4
    libvirt.memory = 8192
  end

  config.vm.synced_folder "salt/roots/", "/srv/"

  config.vm.provision "shell", inline: <<-SHELL
    dnf install -y salt-minion \
    btrfs-progs-devel \
    conmon \
    containernetworking-plugins \
    containers-common \
    crun \
    device-mapper-devel \
    git \
    glib2-devel \
    glibc-devel \
    glibc-static \
    go \
    golang-github-cpuguy83-md2man \
    gpgme-devel \
    iptables \
    libassuan-devel \
    libgpg-error-devel \
    libseccomp-devel \
    libselinux-devel \
    make \
    pkgconfig
  SHELL

  config.vm.provision :salt do |salt|
    salt.masterless = true
    salt.minion_config = "salt/minion"
    salt.run_highstate = false
  end

  config.vm.provision "shell", keep_color: true, inline: <<-SHELL
    salt-call --local --force-color state.apply podman --state-output changes
  SHELL

end
