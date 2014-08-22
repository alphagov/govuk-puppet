# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define govuk::app::service (
  $ensure = 'present',
) {

  $enable_service = hiera('govuk_app_enable_services', true)

  if $ensure == 'absent' {
    service { $title:
      ensure   => stopped,
      provider => 'base',
      pattern  => $title,
    }
  } else {
    service { $title:
      provider => 'upstart',
    }
    if $enable_service {
      Service[$title] {
        ensure => running
      }
    }
  }

}
