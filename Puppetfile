forge "http://forge.puppetlabs.com"

mod 'puppetlabs/apt'
mod 'puppetlabs/gcc'
mod 'puppetlabs/mysql'
mod 'puppetlabs/stdlib'
mod 'ripienaar/concat'
mod 'saz/memcached'
mod 'saz/ntp'
mod 'saz/rsyslog', '2.2.1'
mod 'saz/sudo', '3.0.1'
mod 'saz/timezone'
mod 'thomasvandoren/redis'

# Pinned because of: https://github.com/stankevich/puppet-python/issues/46
mod 'stankevich/python', '1.2.1'

# using git version because we need 93a1765bc09
# which isn't in 0.2.2 (current latest, 2013-11-13)
mod 'nextrevision/automysqlbackup',
  :git => 'git://github.com/nextrevision/puppet-automysqlbackup.git'

# Pinned so we can pick up the config_kernel_variables functionality
# that hasn't been released yet to the forge.
mod 'rabbitmq',
  :git => 'git://github.com/puppetlabs/puppetlabs-rabbitmq.git',
  :ref => '544fb745c94c72de48f40d5522fa09dc58ea14ba'

mod 'apparmor',
  :git => 'git://github.com/alphagov/puppet-apparmor.git'
mod 'aptly',
  :git => 'git://github.com/alphagov/puppet-aptly.git',
  :ref => 'v0.0.1'
mod 'curl',
  :git => 'git://github.com/alphagov/puppet-curl.git',
  :ref => 'f4c6d175bdc6cbd71f71fbaa2544ef8f70c4ce48'
mod 'ext4mount',
  :git => 'git://github.com/alphagov/puppet-ext4mount.git'
mod 'gor',
  :git => 'git://github.com/alphagov/puppet-gor.git',
  :ref => 'v0.2.0'
mod 'harden',
  :git => 'git://github.com/alphagov/puppet-harden.git',
  :ref => 'v0.1.1'
mod 'logstash',
  :git => 'git://github.com/electrical/puppet-logstash.git',
  :ref => '694fa1a'
mod 'lvm',
  :git => 'git://github.com/alphagov/puppetlabs-lvm.git'
mod 'tune_ext',
  :git => 'git://github.com/alphagov/puppet-tune_ext.git'
mod 'ufw',
  :git => 'git://github.com/alphagov/puppet-module-ufw.git',
  :ref => 'dc7ddc2'

# Our modules on the Forge.
mod 'gdsoperations/auditd', '0.0.1'
mod 'gdsoperations/graphite', '1.0.1'
mod 'gdsoperations/openconnect'
mod 'gdsoperations/rbenv', '1.0.1'
mod 'gdsoperations/resolvconf', '0.2.0'
