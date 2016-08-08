# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define govuk::app::service (
  $ensure = 'present',
  $hasrestart = false,
) {

  $enable_service = hiera('govuk_app_enable_services', true)

  if $ensure == 'absent' {
    # Stop the app if it's running.
    # The before will ensure that this gets stopped before the upstart script
    # is removed. And the onlyif prevents this from erroring on future runs.
    exec { "stop-service-${title}":
      command => "service ${title} stop || /bin/true",
      onlyif  => "test -f /etc/init/${title}.conf",
      before  => File["/etc/init/${title}.conf"],
    }
  } else {
    service { $title:
      provider   => 'upstart',
      hasrestart => $hasrestart,
    }
    if $enable_service {
      Service[$title] {
        ensure => running
      }
    }
  }

}
