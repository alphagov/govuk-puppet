# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

  config.ssh.shell = 'bash'

  node_manifest = YAML::load_file(File.expand_path("./vagrant.nodes.yaml", File.dirname(__FILE__)))

  if File.exists?(File.expand_path("./vagrant.nodes.local.yaml", File.dirname(__FILE__))) then
    local_overrides = YAML::load_file(File.expand_path("./vagrant.nodes.local.yaml", File.dirname(__FILE__)))
    node_manifest.merge!(local_overrides)
  end

  defaults = node_manifest['defaults']

  node_names = node_manifest['nodes'].keys.sort
  node_names.each_index do |node_i|
    node_name = node_names[node_i]
    if node_manifest['nodes'][node_name].nil? then
      node_attributes = defaults
    else
      node_attributes = defaults.merge(node_manifest['nodes'][node_name])
    end

    config.vm.define node_name do |c|
      c.vm.box = node_attributes['box']

      if node_attributes['box_url']
        c.vm.box_url = node_attributes['box_url']
      end

      c.vm.hostname = "#{node_name}.dev.gov.uk"
      c.vm.network :private_network, {
        :ip => "10.1.0.#{node_i + 10}",
        :netmask => "255.255.255.0"
      }

      modifyvm_args = ['modifyvm', :id]

      # Mitigate boot hangs.
      modifyvm_args << "--rtcuseutc" << "on"

      # Isolate guests from host networking.
      modifyvm_args << "--natdnsproxy1" << "on"
      modifyvm_args << "--natdnshostresolver1" << "on"

      if node_attributes.has_key?("memory")
        modifyvm_args << "--memory" << node_attributes["memory"]
      end

      c.vm.provider(:virtualbox) { |vb| vb.customize(modifyvm_args) }

      if ENV['VAGRANT_GOVUK_NFS'] == "no"
        c.vm.synced_folder "..", "/var/govuk"
      else
        c.vm.synced_folder "..", "/var/govuk", :nfs => true
      end

      # These can't be NFS because OSX won't export overlapping paths.
      c.vm.synced_folder "gpg", "/etc/puppet/gpg", :owner => 'puppet', :group => 'puppet', type: "rsync"
      # Additional shared folders for Puppet Master nodes.
      if node_name =~ /^puppetmaster/
        c.vm.synced_folder ".", "/usr/share/puppet/production/current"
      end

      node_puppet_role = node_name.split('.')[0].gsub(/[\-0-9]+$/, '')

      c.vm.provision :shell, :path => 'tools/vagrant-bootstrap'
      c.vm.provision :shell, :inline => '/var/govuk/govuk-puppet/tools/mock-ec2-metadata-service.py'
      c.vm.provision :shell, :inline => 'mkdir -p /etc/facter/facts.d'
      c.vm.provision :shell, :inline => "echo 'aws_migration=#{node_puppet_role}' > /etc/facter/facts.d/aws_migration.txt"
      c.vm.provision :shell, :inline => "echo 'aws_stackname=blue' > /etc/facter/facts.d/aws_stackname.txt"

      c.vm.provision :shell,
        inline: '/var/govuk/govuk-puppet/tools/puppet3-bootstrap',
        env: { 'INSTALL_GEMS' => '1' }

      c.vm.provision :shell,
        path: 'tools/puppet-apply',
        args: ENV['VAGRANT_GOVUK_PUPPET_OPTIONS'],
        env: { 'ENVIRONMENT' => 'vagrant' }
    end
  end
end
