# == Class: govuk_prometheus_node_exporter::firewall
#
# Allow Firewall rule into prometheus node-exporter
#
class govuk_prometheus_node_exporter::firewall {
  @ufw::allow { 'allow-prometheus-scraping-from-all':
    port => 9080,
  }
}
