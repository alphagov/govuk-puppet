# == Class: icinga::client::check_unicorn_ruby_version
#
# Install a Nagios plugin that alerts when the the app's currently running ruby
# doesn't match the .ruby-version
#
class icinga::client::check_unicorn_ruby_version {

  @icinga::plugin { 'check_unicorn_ruby_version':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_unicorn_ruby_version',
  }

  @icinga::nrpe_config { 'check_unicorn_ruby_version':
    source  => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_unicorn_ruby_version.cfg',
  }
}
