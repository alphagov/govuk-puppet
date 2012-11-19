define govuk::envvar ($value, $envdir = '/etc/govuk/env.d', $varname = $title) {

  file { "${envdir}/${varname}":
    content => $value,
    require => File[$envdir],
  }

}
