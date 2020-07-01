# == Class: govuk_solr
#
# Installs solr using the embedded version of jetty.
# Configures solr and starts the service.
#
class govuk_solr (
  $jetty_user = 'solr',
  $jetty_host = '127.0.0.1',
  $jetty_port = '8983',
  $solr_home  = '/var/lib/solr',
  $remove     = false,
) {

  ## === Variables === ##
  unless $remove {
    $required_packages = ['openjdk-7-jre']
    $java_home = '/usr/lib/jvm/java-7-openjdk-amd64/jre'
  }

  class{'govuk_solr::install':
    remove => $remove,
  } ~>

  class{'govuk_solr::config':
    jetty_user => $jetty_user,
    solr_home  => $solr_home,
    remove     => $remove,
  }
}
