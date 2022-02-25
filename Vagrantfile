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
    dnf install -y salt-minion
  SHELL

  config.vm.provision :salt do |salt|
    salt.masterless = true
    salt.minion_config = "salt/minion"
    salt.run_highstate = false
  end

  config.vm.provision "shell", keep_color: true, inline: <<-SHELL
    salt-call --local --force-color state.apply podman --state-output changes
  SHELL

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"
end
