# == Define: grafana::dashboards::deployment_dashboard
#
# Automate the creation of app specific deployment Grafana dashboards
#
# === Parameters
#
# [*app_name*]
#   The dashboard application identifier name. This matches the name of the
#   deployed application
#
# [*docs_name*]
#   The dashboard application repository used for linking to the documentation
#   page for the application
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
# [*error_threshold*]
#   Point at which count turns `red` in the error count table data
#
define grafana::dashboards::deployment_dashboard (
  $app_name = $title,
  $docs_name = $title,
  $dashboard_directory = undef,
  $app_domain = undef,
  $has_workers = false,
  $error_threshold = 20,
  $warning_threshold = 10,
  $show_controller_errors = true,
  $show_slow_requests = true
) {
  if $has_workers {
    $worker_row = [['worker_failures', 'worker_successes']]
  } else {
    $worker_row = []
  }

  if $show_controller_errors {
    $errors_by_controller_row = [
      ['errors_by_controller_action']
    ]
  } else {
    $errors_by_controller_row = []
  }

  if $show_slow_requests {
    $duration_by_controller_row = [
      ['response_times_by_controller']
    ]
  } else {
    $duration_by_controller_row = []
  }

  $panel_partials = concat(
    [
      ['processor_count', '5xx_rate'],
      ['error_counts_table', 'links']
    ],
    $worker_row,
    $errors_by_controller_row,
    $duration_by_controller_row
  )

  file {
    "${dashboard_directory}/deployment_${app_name}.json":
    notify  => Service['grafana-server'],
    content => template('grafana/dashboards/deployment_dashboard_template.json.erb');
  }
}
