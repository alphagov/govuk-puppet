# == Class: govuk_heka::global
#
# Global settings for Heka.
#
class govuk_heka::global {
  heka::plugin { 'global':
    source => 'puppet:///modules/govuk_heka/etc/heka/global.toml',
  }
}
