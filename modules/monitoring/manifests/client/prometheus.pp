# == Class: monitoring::client::prometheus
#
# Install Prometheus client exporters
class monitoring::client::prometheus {
  if $::aws_migration == 'jumpbox' {

    file { ['/var/lib/node_exporter', '/var/lib/node_exporter/textfile_collector']:
      ensure => directory,
    }

    class { '::prometheus::node_exporter':
      version       => '0.14.0',
      collectors    => ['diskstats','filesystem','loadavg','meminfo','stat','time','netdev'],
      extra_options => '-web.listen-address ":9091" -collector.textfile.directory "/var/lib/node_exporter/textfile_collector"',
      require       => File['/var/lib/node_exporter/textfile_collector'],
    }

    @ufw::allow { 'allow-node_exporter-http-9091':
      port => 9091,
    }
  }
}
