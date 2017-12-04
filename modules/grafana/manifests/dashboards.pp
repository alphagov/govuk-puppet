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
# [*deployment_applications*]
#   Hash of application that require a deployment dashboard
#
class grafana::dashboards (
  $app_domain = undef,
  $machine_suffix_metrics = undef,
  $deployment_applications = undef,
) {
  validate_string($app_domain, $machine_suffix_metrics)

  $dashboard_directory = '/etc/grafana/dashboards'

  $app_domain_metrics = regsubst($app_domain, '\.', '_', 'G')

  $index_names = ['govuk', 'mainstream', 'government', 'detailed']

  file { $dashboard_directory:
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/grafana/dashboards',
  }
  file {
    "${dashboard_directory}/2ndline_health.json": content => template('grafana/dashboards/2ndline_health.json.erb');
    "${dashboard_directory}/application_http_error_codes.json": content => template('grafana/dashboards/application_http_error_codes.json.erb');
    "${dashboard_directory}/application_health.json": content => template('grafana/dashboards/application_health.json.erb');
    "${dashboard_directory}/edge_health.json": content => template('grafana/dashboards/edge_health.json.erb');
    "${dashboard_directory}/origin_health.json": content => template('grafana/dashboards/origin_health.json.erb');
    "${dashboard_directory}/whitehall_health.json": content => template('grafana/dashboards/whitehall_health.json.erb');
    "${dashboard_directory}/publishing_api_overview.json": content => template('grafana/dashboards/publishing_api_overview.json.erb');
    "${dashboard_directory}/rummager_index_size.json": content => template('grafana/dashboards/rummager_index_size.json.erb');
  }

  create_resources('grafana::dashboards::deployment_dashboard', $deployment_applications, {
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
    }
  }
}
