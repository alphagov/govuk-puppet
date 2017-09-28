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

  # scrape_configs and alerts parameters are configured in Hieradata
  class { '::prometheus':
    version        => '1.7.1',
    init_style     => 'debian',
    extra_options  => '-alertmanager.url http://localhost:9093 -web.console.templates=/opt/prometheus-1.7.1.linux-amd64/consoles -web.console.libraries=/opt/prometheus-1.7.1.linux-amd64/console_libraries',
  }

  @ufw::allow { 'allow-prometheus-http-9090':
    port => 9090,
  }

  class { '::prometheus::alertmanager':
    version      => '0.9.0',
    init_style   => 'debian',
    service_name => 'alertmanager',
  }

  @ufw::allow { 'allow-prometheus-alertmanager-http-9093':
    port => 9093,
  }
}
