# FQDN fact with dots replaced by underscores. This matches the naming
# convention within Graphite.

Facter.add("fqdn_underscore") do
 setcode do
    fqdn = Facter.value("fqdn")
    fqdn.gsub(/\./, '_')
  end
end
