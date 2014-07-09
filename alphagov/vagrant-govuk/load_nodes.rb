require 'json'

# Load node definitions from the JSON in the vcloud-templates repo parallel
# to this.
def load_nodes
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
