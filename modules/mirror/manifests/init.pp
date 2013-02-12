class mirror {

  file { '/usr/local/bin/govuk_update_mirror':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/mirror/govuk_update_mirror',
  }

  package { 'spidey':
    ensure   => present,
    provider => gem,
    require  => Package['libxml2-dev'],
  }

  file { '/usr/local/bin/govuk_mirrorer':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///modules/mirror/govuk_mirrorer',
    require => Package['spidey'],
  }

  file { '/var/lib/govuk_mirror':
    ensure => directory,
  }

  file { '/etc/init/govuk_update_mirror.conf':
    content => '
task
env MIRRORER_SITE_ROOT=https://www.gov.uk
export MIRRORER_SITE_ROOT
exec /usr/local/bin/govuk_update_mirror
',
    require => File['/usr/local/bin/govuk_update_mirror'],
  }

  file { '/etc/init/govuk_update_netstorage.conf':
    content => '
task
start on stopped govuk_update_mirror
exec sudo -u govuk-netstorage rsync -e ssh -rLptgoD -z --delete \
             /var/lib/govuk_mirror/current/. \
             sshacs@gdscontent.upload.akamai.com:/188296/staticsite/govuk-mirror
',
  }

  cron { 'update-latest-to-mirror':
    ensure  => present,
    user    => 'root',
    hour    => '0',
    minute  => '0',
    command => '/sbin/start govuk_update_mirror',
    require => File['/etc/init/govuk_update_mirror.conf'],
  }

}
