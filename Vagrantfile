# -*- mode: ruby -*-
# vi: set ft=ruby :

def nodes
  %w(
    apt
    asset_master
    backend
    bouncer
    cache
    calculators_frontend
    content_store
    db_admin
    deploy
    docker_management
    draft_cache
    draft_content_store
    draft_frontend
    frontend
    graphite
    jumpbox
    logs_cdn
    mapit
    mirrorer
    mongo
    monitoring
    mysql
    publishing_api
    puppetmaster
    rabbitmq
    router_backend
    rummager_elasticsearch
    search
    transition_db_admin
    whitehall_backend
    whitehall_frontend
  )
end

Vagrant.configure("2") do |config|
  # Enable vagrant-cachier if available.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

  config.ssh.shell = 'bash'

  nodes.each do |node|
    config.vm.define node do |c|
      c.vm.box = 'ubuntu/trusty64'
      config.vm.network "private_network", type: "dhcp"

      modifyvm_args = ['modifyvm', :id]

      # Isolate guests from host networking.
      modifyvm_args << "--natdnsproxy1" << "on"
      modifyvm_args << "--natdnshostresolver1" << "on"

      c.vm.provider(:virtualbox) { |vb| vb.customize(modifyvm_args) }

      if ENV['VAGRANT_GOVUK_NFS'] == "no"
        c.vm.synced_folder "..", "/var/govuk"
      else
        c.vm.synced_folder "..", "/var/govuk", :nfs => true
      end

      # These can't be NFS because OSX won't export overlapping paths.
      c.vm.synced_folder "gpg", "/etc/puppet/gpg", :owner => 'puppet', :group => 'puppet', type: "rsync"
      # Additional shared folders for Puppet Master nodes.
      if node =~ /^puppetmaster/
        c.vm.synced_folder ".", "/usr/share/puppet/production/current"
      end

      # FIXME: The jenkins class should be renamed deploy in the future
      if node =~ /^deploy/
        node == 'jenkins'
      end

      # vagrant-userdata copies the base userdata used in AWS launch configuration
      c.vm.provision :shell, :inline => "/var/govuk/govuk-puppet/tools/vagrant-userdata #{node}"
      c.vm.provision :shell, :inline => "ENVIRONMENT=vagrant /var/govuk/govuk-puppet/tools/puppet-apply #{ENV['VAGRANT_GOVUK_PUPPET_OPTIONS']}"
    end
  end
end
