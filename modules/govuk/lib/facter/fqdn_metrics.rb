# FQDN fact with dots replaced by underscores and truncated intelligently so as
# to avoid exceeding collectd's 63-byte limit on the host field.
# This matches the naming convention within Graphite.

Facter.add("fqdn_metrics") do
 setcode do
    if Facter.value("aws_migration").nil?
      fqdn_metrics = Facter.value("fqdn_short").dup
    else
      fqdn_metrics = "#{Facter.value(:aws_hostname)}.#{Facter.value(:aws_stackname)}.#{Facter.value(:aws_environment)}"
    end

    fqdn_metrics.gsub!(/\./, '_')

    fqdn_metrics
  end
end
