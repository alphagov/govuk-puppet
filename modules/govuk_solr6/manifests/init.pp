# == Class: govuk_solr
#
# Installs, configures solr and starts the service.
#
# === Parameters
#
# [*solr_home*]
#   The home directory for solr.
#
# [*solr_host*]
#   "control the hostname exposed to cluster"
#
# [*solr_install_dir*]
#   Where the solr code will be installed
#
# [*solr_log_dir*]
#   Log directory
#
# [*solr_pid_dir*]
#   Directory to keep pidfiles
#
# [*solr_port*]
#   Port for solr to listen on
#
# [*solr_user*]
#   User name to run solr as
#
# [*solr_home*]
#   Where solr's data will be kept
#
class govuk_solr6 (
  $solr_user = 'solr',
  $solr_host = '127.0.0.1',
  $solr_port = '8983',
  $solr_home  = '/var/lib/solr',
  $solr_install_dir  = '/opt/solr',
  $solr_log_dir  = '/var/log/solr',
  $solr_pid_dir  = '/var/run/solr',
) {

  ## === Variables === ##
  $required_packages = ['openjdk-8-jre']
  $java_home = '/usr/lib/jvm/java-8-openjdk-amd64/jre'

  class{'govuk_solr::install':
    solr_home        => $solr_home,
    solr_host        => $solr_host,
    solr_install_dir => $solr_install_dir,
    solr_log_dir     => $solr_log_dir,
    solr_pid_dir     => $solr_pid_dir,
    solr_port        => $solr_port,
    solr_user        => $solr_user,
  } ~>

  class{'govuk_solr::config':
    solr_home        => $solr_home,
    solr_install_dir => $solr_install_dir,
    solr_user        => $solr_user,
  }
}
