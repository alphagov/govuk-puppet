# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::deploy (
    $setup_actionmailer_ses_config = true,
    $actionmailer_enable_delivery = true,
    $aws_ses_smtp_host = 'UNSET',
    $aws_ses_smtp_username = 'UNSET',
    $aws_ses_smtp_password = 'UNSET',
){
  include govuk_harden
  include govuk_logging
  include govuk_python
  include unicornherder

  validate_bool($setup_actionmailer_ses_config)
  validate_bool($actionmailer_enable_delivery)

  anchor { 'govuk::deploy::begin': }

  # These resources are required, but should not refresh apps.
  class { 'govuk::deploy::setup':
    actionmailer_enable_delivery  => $actionmailer_enable_delivery,
    setup_actionmailer_ses_config => $setup_actionmailer_ses_config,
    aws_ses_smtp_host             => $aws_ses_smtp_host,
    aws_ses_smtp_username         => $aws_ses_smtp_username,
    aws_ses_smtp_password         => $aws_ses_smtp_password,
    require                       => Anchor['govuk::deploy::begin'],
  }

  # These resources should refresh apps.
  class { 'govuk::deploy::config':
    require => Class['govuk::deploy::setup'],
  }

  anchor { 'govuk::deploy::end':
    subscribe => Class['govuk::deploy::config'],
    require   => Class['unicornherder'],
  }
}
