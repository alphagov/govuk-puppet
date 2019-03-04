# == Class: grafana::dashboards
#
# Set up monitoring dashboards for grafana.
#
# === Parameters
#
# [*app_domain*]
#   The suffix that applications use for their domain names.
#
# [*machine_suffix_metrics*]
#   The machine hostname suffix for Graphite metrics.
#
# [*application_dashboards*]
#   Hash of applications to create dashboards for.
#
class grafana::dashboards (
  $app_domain = undef,
  $machine_suffix_metrics = undef,
  $application_dashboards = undef,
) {
  validate_string($app_domain, $machine_suffix_metrics)

  $dashboard_directory = '/etc/grafana/dashboards'

  $app_domain_metrics = regsubst($app_domain, '\.', '_', 'G')

  $index_names = ['govuk', 'government', 'detailed']

  file { $dashboard_directory:
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/grafana/dashboards',
  }
  file {
    "${dashboard_directory}/publishing_api_overview.json": content => template('grafana/dashboards/publishing_api_overview.json.erb');
    "${dashboard_directory}/rummager_index_size.json": content => template('grafana/dashboards/rummager_index_size.json.erb');
  }

  create_resources('grafana::dashboards::application_dashboard', $application_dashboards, {
    'dashboard_directory' => $dashboard_directory,
    'app_domain'          => $app_domain,
  })

  if $::aws_migration {
    file {
      "${dashboard_directory}/aws-auto-scaling.json": source => 'puppet:///modules/grafana/dashboards_aws/aws-auto-scaling.json';
      "${dashboard_directory}/aws-ec2.json": source => 'puppet:///modules/grafana/dashboards_aws/aws-ec2.json';
      "${dashboard_directory}/aws-efs.json": source => 'puppet:///modules/grafana/dashboards_aws/aws-efs.json';
      "${dashboard_directory}/aws-elb-classic-load-balancer.json": source => 'puppet:///modules/grafana/dashboards_aws/aws-elb-classic-load-balancer.json';
      "${dashboard_directory}/aws-rds.json": source => 'puppet:///modules/grafana/dashboards_aws/aws-rds.json';
      "${dashboard_directory}/aws-s3.json": source => 'puppet:///modules/grafana/dashboards_aws/aws-s3.json';
      "${dashboard_directory}/detailed_search_api_queues.json": source => 'puppet:///modules/grafana/dashboards_aws/detailed_search_api_queues.json';
      "${dashboard_directory}/search_api_elasticsearch.json": source => 'puppet:///modules/grafana/dashboards_aws/search_api_elasticsearch.json';
      "${dashboard_directory}/search_api_queues.json": source => 'puppet:///modules/grafana/dashboards_aws/search_api_queues.json';
      "${dashboard_directory}/search_api_index_size.json": content => template('grafana/dashboards_aws/search_api_index_size.json.erb');
    }
  }
}
