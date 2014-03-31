require 'json'

min_required_vagrant_version = '1.3.0'

# Construct box name and URL from distro and version.
def get_box(dist, version)
  dist    ||= "precise"
  version ||= "20140318"

  name  = "govuk_dev_#{dist}64_#{version}"
  url   = "http://gds-boxes.s3.amazonaws.com/#{name}.box"

  return name, url
end

# Load node definitions from the JSON in the vcloud-templates repo parallel
# to this.
def nodes_from_json
  json_dir = File.expand_path("../../vcloud-templates/machines", __FILE__)
  json_local = File.expand_path("../nodes.local.json", __FILE__)

  unless File.exists?(json_dir)
    puts "Unable to find nodes in 'vcloud-templates' repo"
    puts
    return {}
  end

  json_files = Dir.glob(
    File.join(json_dir, "**", "*.json")
  )

  nodes = Hash[
    json_files.map { |json_file|
      node = JSON.parse(File.read(json_file))
      name = node["vm_name"] + "." + node["zone"]

      # Ignore physical attributes.
      node.delete("memory")
      node.delete("num_cores")

      [name, node]
    }
  ]

  # Local JSON file can override node properties like "memory".
  if File.exists?(json_local)
    nodes_local = JSON.parse(File.read(json_local))
    nodes_local.each { |k,v| nodes[k].merge!(v) if nodes.has_key?(k) }
  end

  nodes
end

if Vagrant::VERSION < min_required_vagrant_version
  $stderr.puts "ERROR: Puppet now requires Vagrant version >=#{min_required_vagrant_version}. Please upgrade.\n"
  exit 1
end

Vagrant.configure("2") do |config|
  # Enable vagrant-cachier if available.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

  nodes_from_json.each do |node_name, node_opts|
    config.vm.define node_name do |c|
      box_name, box_url = get_box(
        node_opts["box_dist"],
        node_opts["box_version"]
      )
      c.vm.box = box_name
      c.vm.box_url = box_url
      c.vm.hostname = "#{node_name}.development"
      c.vm.network :private_network, {
        :ip => node_opts["ip"],
        :netmask => "255.255.000.000"
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

      # Additional shared folders for Puppet Master nodes.
      # These can't be NFS because OSX won't export overlapping paths.
      if node_name =~ /^puppetmaster/
        c.vm.synced_folder "../puppet", "/usr/share/puppet/production/current"
      end

      c.vm.provision :shell, :inline => "ENVIRONMENT=vagrant FACTER_govuk_platform=staging /var/govuk/puppet/tools/puppet-apply #{ENV['VAGRANT_GOVUK_PUPPET_OPTIONS']}"
    end
  end
end
