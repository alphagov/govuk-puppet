# FQDN fact with dots replaced by underscores and truncated intelligently so as
# to avoid exceeding collectd's 63-byte limit on the host field.
# This matches the naming convention within Graphite.

Facter.add("fqdn_metrics") do
 setcode do
    fqdn = Facter.value("fqdn").dup
    fqdn.gsub!(/\./, '_')
    fqdn.gsub!(/_publishing_service_gov_uk$/, '')

    fqdn
  end
end
