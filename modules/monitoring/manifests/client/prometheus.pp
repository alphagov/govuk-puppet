# == Class: monitoring::client::prometheus
#
# Install Prometheus client exporters
class monitoring::client::prometheus {
  if $::aws_migration == 'jumpbox' {
    class { '::prometheus::node_exporter':
      version    => '0.14.0',
      collectors => ['diskstats','filesystem','loadavg','meminfo','stat','time'],
    }

    @ufw::allow { 'allow-node_exporter-http-9100':
      port => 9100,
    }
  }
}
