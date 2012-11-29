class varnish::config {

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
    'calculate-your-redundancy-pay',
    'can-i-get-a-british-passport',
    'child-benefit-tax-calculator',
    'childcare-costs-for-tax-credits',
    'claim-a-national-insurance-refund',
    'driving-in-great-britain-on-non-gb-licence',
    'estimate-self-assessment-penalties',
    'exchange-a-foreign-driving-licence',
    'inherits-someone-dies-without-will',
    'legal-right-to-work-in-the-uk',
    'maternity-benefits',
    'maternity-paternity-calculator',
    'plan-adoption-leave',
    'plan-maternity-leave',
    'plan-paternity-leave',
    'recognise-a-trade-union',
    'register-a-death',
    'report-a-lost-or-stolen-passport',
    'request-for-flexible-working',
    'student-finance-calculator',
    'towing-rules',
    'vehicles-you-can-drive',
    'which-finance-is-right-for-your-business'
  ]

  # List of available backends
  $backends = [
    'businesssupportfinder',
    'calendars',
    'canary_frontend',
    'datainsight_frontend',
    'designprinciples',
    'feedback',
    'frontend',
    'licencefinder',
    'licensify',
    'publicapi',
    'search',
    'smartanswers',
    'static',
    'tariff',
    'whitehall_frontend'
  ]

  $domain = extlookup('app_domain')

  file { '/etc/default/varnish':
    ensure  => file,
    content => template('varnish/defaults.erb'),
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
