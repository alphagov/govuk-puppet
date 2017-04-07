# == Define: grafana::dashboards::deployment_dashboard
#
# Automate the creation of app specific deployment Grafana dashboards
#
# === Parameters
#
# [*app_name*]
#   The dashboard application identifier name. This matches the name of the
#   name of the deployed application
#
# [*dashboard_directory*]
#   The directory where the Grafana config json files are created
#
# [*app_domain*]
#   The suffix that applications use for their domain names
#
# [*has_workers*]
#   Whether the application uses workers
#
define grafana::dashboards::deployment_dashboard (
  $app_name = $title,
  $dashboard_directory = undef,
  $app_domain = undef,
  $has_workers = true,
) {
  file {
    "${dashboard_directory}/deployment_${app_name}.json": content => template('grafana/dashboards/deployment_dashboard_template.json.erb');
  }
}
