require 'yaml'

# Load node definitions from the vcloud-launcher YAML in the
# govuk-provisioning repo parallel to this.
def load_nodes
  yaml_dir = File.expand_path(
    "../../govuk-provisioning/vcloud-launcher/*integration_carrenza/",
    __FILE__
  )
  yaml_local = File.expand_path("../nodes.local.yaml", __FILE__)

  # DEPRECATED
  json_local = File.expand_path("../nodes.local.json", __FILE__)
  if File.exists?(json_local)
    $stderr.puts "ERROR: nodes.local.json is deprecated. Please convert it to YAML"
    exit 1
  end

  unless Dir.glob(yaml_dir).any?
    puts "Unable to find nodes in 'govuk-provisioning' repo"
    puts
    return {}
  end

  yaml_files = Dir.glob(
    File.join(yaml_dir, "*.yaml")
  )

  nodes = Hash[
    yaml_files.flat_map { |yaml_file|
      YAML::load_file(yaml_file).fetch('vapps').map { |vapp|
        name    = vapp.fetch('name')
        template = vapp.fetch('vapp_template_name')
        vm      = vapp.fetch('vm')
        network = vm.fetch('network_connections').first
        vdc     = network.fetch('name').downcase

        name = "#{name}.#{vdc}"
        config = {
          'ip' => network.fetch('ip_address'),
        }

        config['box_dist'] = ['precise', 'trusty', 'xenial'].find { |dist| vapp['vapp_template_name'].include? dist }

        [name, config]
      }
    }
  ]

  # Local YAML file can override node properties like "memory". It should
  # look like:
  #
  # ---
  # machine1.vdc1:
  #   memory: 128
  # machine2.vdc2:
  #   memory: 4096
  #
  if File.exists?(yaml_local)
    nodes_local = YAML::load_file(yaml_local)
    nodes_local.each { |k,v| nodes[k].merge!(v) if nodes.has_key?(k) }
  end

  Hash[nodes.sort]
end
