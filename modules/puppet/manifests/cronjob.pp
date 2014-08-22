# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::cronjob {

  $first = fqdn_rand(30)
  $second = $first + 30

  cron { 'puppet':
    ensure  => present,
    user    => 'root',
    minute  => [$first, $second],
    command => '/usr/local/bin/govuk_puppet',
    require => File['/usr/local/bin/govuk_puppet'],
  }
}
