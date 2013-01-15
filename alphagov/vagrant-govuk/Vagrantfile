require 'json'

BOX_VERSION = "20121220"
BOX_DIST    = "precise"
BOX_NAME    = "govuk_dev_#{BOX_DIST}64_#{BOX_VERSION}"
BOX_URL     = "http://gds-boxes.s3.amazonaws.com/#{BOX_NAME}.box"

# Load node definitions from the JSON in the deployment repo parallel to
# this. Temporary solution while only Ops are using this.
def nodes_from_json
  json_dir = File.expand_path("../../deployment/provisioner/machines", __FILE__)

  unless File.exists?(json_dir)
    puts "Unable to find nodes in 'deployment' repo"
    puts
    return {}
  end

  json_files = Dir.glob(
    File.join(json_dir, "**", "*.json")
  )

  nodes = json_files.map { |json_file|
    node = JSON.parse(File.read(json_file))
    name = node["vm_name"] + "." + node["zone"]

    [name, { :ip => node["ip"], :class => node["class"] }]
  }

  Hash[nodes]
end

Vagrant::Config.run do |config|
  nodes_from_json.each do |node_name, node_opts|
    config.vm.define node_name do |c|
      c.vm.box = BOX_NAME
      c.vm.box_url = BOX_URL
      c.vm.host_name = ENV['VAGRANT_HOSTNAME'] || 'vm'

      c.vm.network :hostonly, node_opts[:ip]

      # Mitigate boot hangs.
      c.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]

      c.ssh.forward_agent = true
      c.vm.share_folder "govuk", "/var/govuk", "..", :nfs => true
    end
  end
end
