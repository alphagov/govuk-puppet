# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::puppetserver::config {

  $java_args = '-Xms12g -Xmx12g -XX:MaxPermSize=1g'

  file {'/etc/puppet/puppetdb.conf':
    content => template('puppet/etc/puppet/puppetdb.conf.erb'),
  }
  file {'/etc/puppet/routes.yaml':
    source => 'puppet:///modules/puppet/etc/puppet/routes.yaml',
  }
  file { '/usr/local/bin/puppet_config_version':
    ensure => present,
    source => 'puppet:///modules/puppet/usr/local/bin/puppet_config_version',
    mode   => '0755',
  }
  file { '/etc/puppet/certsigner.rb':
    ensure => present,
    source => 'puppet:///modules/puppet/etc/puppet/certsigner.rb',
    mode   => '0755',
  }

  file_line { 'default_puppetserver':
    ensure => present,
    path   => '/etc/default/puppetserver',
    line   => inline_template("JAVA_ARGS=\"${java_args}\""),
    match  => '^JAVA_ARGS=',
  }

  file_line { 'initd_puppetserver':
    ensure => present,
    path   => '/etc/init.d/puppetserver',
    line   => 'EXEC="$JAVA_BIN -XX:OnOutOfMemoryError=\"kill -9 %p; /etc/init.d/puppetdb restart; /etc/init.d/puppetserver restart\" -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/$NAME -Djava.security.egd=/dev/urandom $JAVA_ARGS"',
    match  => '^EXEC=\"\$JAVA_BIN -XX:OnOutOfMemoryError=',
  }

  # Track checksums and reload `puppetmaster` service when they change. This
  # is still pretty non-deterministic because it requires a `puppet agent`
  # run on the master after deployment and then a wait for `unicornherder`
  # to do its thing. Workarounds for the issues:

  # https://tickets.puppetlabs.com/browse/PUP-1336
  file { '/usr/share/puppet/production/current/hiera.yml':
    ensure => undef,
    owner  => undef,
    group  => undef,
    mode   => undef,
    audit  => 'content',
  }

  # https://tickets.puppetlabs.com/browse/PUP-1033
  file { [
    '/var/lib/puppet/lib/puppet/type',
    '/var/lib/puppet/lib/puppet/parser',
    ]:
    ensure  => undef,
    owner   => undef,
    group   => undef,
    mode    => undef,
    recurse => true,
    audit   => 'content',
  }
}
