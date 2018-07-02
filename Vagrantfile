# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'load_nodes'

min_required_vagrant_version = '1.3.0'

# Construct box name and URL from distro and version.
def get_box(dist, version)
  dist    ||= "trusty"
  version ||= '20160323'
  
  name  = "govuk_dev_#{dist}64_#{version}"
  bucket = 'govuk-dev-boxes-test'
  url = "https://#{bucket}.s3.amazonaws.com/#{name}.box"

  return name, url
end

if Vagrant::VERSION < min_required_vagrant_version
  $stderr.puts "ERROR: Puppet now requires Vagrant version >=#{min_required_vagrant_version}. Please upgrade.\n"
  exit 1
end

nodes = load_nodes()
Vagrant.configure("2") do |config|
  # Enable vagrant-cachier if available.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

  config.ssh.shell = 'bash'

  nodes.each do |node_name, node_opts|
    config.vm.define node_name do |c|
      box_name, box_url = get_box(
        node_opts["box_dist"],
        node_opts["box_version"],
      )
      c.vm.box = box_name
      c.vm.box_url = box_url
      c.vm.hostname = "#{node_name}.dev.gov.uk"
      c.vm.network :private_network, {
        :ip => node_opts["ip"],
        :netmask => "255.000.000.000"
      }

      modifyvm_args = ['modifyvm', :id]

      # Mitigate boot hangs.
      modifyvm_args << "--rtcuseutc" << "on"

      # Isolate guests from host networking.
      modifyvm_args << "--natdnsproxy1" << "on"
      modifyvm_args << "--natdnshostresolver1" << "on"

      if node_opts.has_key?("memory")
        modifyvm_args << "--memory" << node_opts["memory"]
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

      # This feels like a bit of a hack and there's probably a better way to do this...
      # The hostname should come from the role, not the other way round
      puppet_role = node_name.split('.')[0].gsub(/[\-0-9]+$/, '')

      # run a script to partition extra disks for lvm if they exist.
      c.vm.provision :shell, :inline => "/var/govuk/govuk-puppet/tools/partition-disks"
      c.vm.provision :shell, :inline => '/var/govuk/govuk-puppet/tools/mock-ec2-metadata-service.py'
      c.vm.provision :shell, :inline => 'mkdir -p /etc/facter/facts.d'
      c.vm.provision :shell, :inline => "echo 'aws_migration=#{puppet_role}' > /etc/facter/facts.d/aws_migration.txt"
      c.vm.provision :shell, :inline => "echo 'aws_stackname=blue' > /etc/facter/facts.d/aws_stackname.txt"
      c.vm.provision :shell, :inline => "ENVIRONMENT=development /var/govuk/govuk-puppet/tools/puppet-apply #{ENV['VAGRANT_GOVUK_PUPPET_OPTIONS']}"
    end
  end
end
