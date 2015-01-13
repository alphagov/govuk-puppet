# == Class: govuk_heka::global
#
# Global settings for Heka.
#
class govuk_heka::global {
  $heka_maxprocs = $::processorcount

  heka::plugin { 'global':
    content => template('govuk_heka/etc/heka/global.toml.erb'),
  }
}
