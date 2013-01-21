require 'json'

BOX_VERSION = "20121220"
BOX_DIST    = "precise"
BOX_NAME    = "govuk_dev_#{BOX_DIST}64_#{BOX_VERSION}"
BOX_URL     = "http://gds-boxes.s3.amazonaws.com/#{BOX_NAME}.box"

# Load node definitions from the JSON in the deployment repo parallel to
# this. Temporary solution while only Ops are using this.
def nodes_from_json
  json_dir = File.expand_path("../../deployment/provisioner/machines", __FILE__)
  json_local = File.expand_path("../nodes.local.json", __FILE__)

  unless File.exists?(json_dir)
    puts "Unable to find nodes in 'deployment' repo"
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

Vagrant::Config.run do |config|
  nodes_from_json.each do |node_name, node_opts|
    config.vm.define node_name do |c|
      c.vm.box = BOX_NAME
      c.vm.box_url = BOX_URL

      c.vm.host_name = node_name
      c.vm.network :hostonly, node_opts["ip"]

      modifyvm_args = ['modifyvm', :id]

      # Mitigate boot hangs.
      modifyvm_args << "--rtcuseutc" << "on"

      # Isolate guests from host networking.
      modifyvm_args << "--natdnsproxy1" << "on"
      modifyvm_args << "--natdnshostresolver1" << "on"

      if node_opts.has_key?("memory")
        modifyvm_args << "--memory" << node_opts["memory"]
      end

      c.vm.customize(modifyvm_args)

      c.ssh.forward_agent = true
      c.vm.share_folder "govuk", "/var/govuk", "..", :nfs => true

      # Additional shared folders for Puppet Master nodes.
      # These can't been NFS because OSX won't export overlapping paths.
      if node_opts["class"] == "puppet"
        c.vm.share_folder "pm-puppet",
          "/usr/share/puppet/production/current",
          "../puppet"
        c.vm.share_folder "pm-extdata",
          "/usr/share/puppet/production/current/extdata",
          "../deployment/puppet/extdata"
      end

      c.vm.provision :puppet do |puppet|
        puppet.manifest_file = "site.pp"
        puppet.manifests_path = "../puppet/manifests"
        puppet.module_path = [
          "../puppet/modules",
          "../puppet/vendor/modules",
        ]
        puppet.facter = {
          :govuk_class => node_opts["class"],
          :govuk_provider => "sky",
          :govuk_platform => "staging",
        }
      end
    end
  end
end
