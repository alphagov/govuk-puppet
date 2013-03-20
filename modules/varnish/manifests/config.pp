class varnish::config {
  # VCL syntax is different between major versions.
  $vcl_version = $::lsbdistcodename ? {
    'precise' => 3,
    default   => 2,
  }

  include varnish::restart

  # A list of smartanswers to make them easy to maintain
  $smartanswers = [
    'additional-commodity-code',
    'am-i-getting-minimum-wage',
    'apply-for-probate',
    'auto-enrolled-into-workplace-pension',
    'become-a-driving-instructor',
    'become-a-motorcycle-instructor',
    'benefits-if-you-are-abroad',
    'calculate-agricultural-holiday-entitlement',
    'calculate-employee-redundancy-pay',
    'calculate-married-couples-allowance',
    'calculate-night-work-hours',
    'calculate-state-pension',
    'calculate-statutory-sick-pay',
    'calculate-your-child-maintenance',
    'calculate-your-holiday-entitlement',
    'calculate-your-maternity-pay',
    'calculate-your-redundancy-pay',
    'can-i-get-a-british-passport',
    'child-benefit-tax-calculator',
    'childcare-costs-for-tax-credits',
    'claim-a-national-insurance-refund',
    'energy-grants-calculator',
    'estimate-self-assessment-penalties',
    'exchange-a-foreign-driving-licence',
    'help-if-you-are-arrested-abroad',
    'inherits-someone-dies-without-will',
    'legal-right-to-work-in-the-uk',
    'maternity-paternity-calculator',
    'non-gb-driving-licence',
    'overseas-passports',
    'pip-checker',
    'plan-adoption-leave',
    'plan-maternity-leave',
    'plan-paternity-leave',
    'recognise-a-trade-union',
    'register-a-death',
    'report-a-lost-or-stolen-passport',
    'request-for-flexible-working',
    'student-finance-calculator',
    'student-finance-forms',
    'towing-rules',
    'vehicles-you-can-drive',
    'which-finance-is-right-for-your-business'
  ]

  # List of available backends
  $all_backends = [
    'businesssupportfinder',
    'calendars',
    'canary_frontend',
    'datainsight_frontend',
    'designprinciples',
    'feedback',
    'frontend',
    'licencefinder',
    'licensify',
    'limelight',
    'publicapi',
    'search',
    'smartanswers',
    'static',
    'tariff',
    'whitehall_frontend'
  ]

  $app_domain = extlookup('app_domain')
  $transaction_wrappers_enabled = str2bool(extlookup('govuk_enable_transaction_wrappers', 'no'))

  if $transaction_wrappers_enabled {
    $backends = flatten([$all_backends,'transaction_wrappers'])
  } else {
    $backends = $all_backends
  }

  file { '/etc/default/varnish':
    ensure  => file,
    content => template('varnish/defaults.erb'),
    notify  => Class['varnish::restart'], # requires a full varnish restart to pick up changes
  }

  file { '/etc/default/varnishncsa':
    ensure  => file,
    source  => 'puppet:///modules/varnish/etc/default/varnishncsa',
  }

  file { '/etc/varnish/default.vcl':
    ensure  => file,
    content => template("varnish/default.vcl.erb"),
  }
}
