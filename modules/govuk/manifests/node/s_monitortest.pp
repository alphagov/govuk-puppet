# == Class: govuk::node::s_monitoring
#
# This class sets up a monitoring machine.
#
# === Parameters
#
# [*enable_fastly_metrics*]
#   Boolean, whether collectd should pull metrics using Fastly's API
#
# [*offsite_backups*]
#   Boolean, whether the offsite backup machines should be monitored
#
class govuk::node::s_monitortest {

  include ::govuk::node::s_base

  $numeric_port = scanf('9091', "%i")

  class { 'prometheus':
    version        => '1.7.1',
    init_style     => 'debian',
    scrape_configs => [
      {
        'job_name'        => 'prometheus',
        'scrape_interval' => '30s',
        'scrape_timeout'  => '30s',
        'ec2_sd_configs'  => [
          {
            'region'  => $::aws_region,
            'profile' => "${::aws_stackname}-${::aws_migration}",
            'port'    => $numeric_port[0],
          },
        ],
        'static_configs'  => [
          {
            'targets' => [
              'localhost:9090',
            ],
            'labels'  => {
              'alias' => 'Prometheus',
            },
          },
        ],
      },
    ],
    extra_options  => '-alertmanager.url http://localhost:9093 -web.console.templates=/opt/prometheus-1.7.1.linux-amd64/consoles -web.console.libraries=/opt/prometheus-1.7.1.linux-amd64/console_libraries',
  }

  @ufw::allow { 'allow-prometheus-http-9090':
    port => 9090,
  }

}
