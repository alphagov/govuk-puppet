class hosts {
  case $::govuk_platform {
    production: { include hosts::production }
    preview:    { include hosts::preview }
    default:    { include hosts::development }
  }
}

class hosts::ertp {
  case $::govuk_platform {
    default:    { include hosts::ertp-preview }
  }
}


class hosts::production {
  # TODO: Find out if these are used and if, instead, we can just use the
  # DNS and hit the public IP for them.

  host { 'static.production.alphagov.co.uk':            ip => '10.53.54.49' }
  host { 'fco.production.alphagov.co.uk':               ip => '10.53.54.49' }
  host { 'jobs.production.alphagov.co.uk':              ip => '10.53.54.49' }
  host { 'smartanswers.production.alphagov.co.uk':      ip => '10.53.54.49' }
  host { 'frontend.production.alphagov.co.uk':          ip => '10.53.54.49' }
  host { 'search.production.alphagov.co.uk':            ip => '10.53.54.49' }
  host { 'planner.production.alphagov.co.uk':           ip => '10.53.54.49' }
  host { 'calendars.production.alphagov.co.uk':         ip => '10.53.54.49' }
  host { 'signonotron.production.alphagov.co.uk':       ip => '10.54.182.112' }
  host { 'panopticon.production.alphagov.co.uk':        ip => '10.54.182.112' }
  host { 'needotron.production.alphagov.co.uk':         ip => '10.54.182.112' }
  host { 'imminence.production.alphagov.co.uk':         ip => '10.54.182.112' }
  host { 'publisher.production.alphagov.co.uk':         ip => '10.54.182.112' }
  host { 'private-frontend.production.alphagov.co.uk':  ip => '10.54.182.112' }
  host { 'contactotron.production.alphagov.co.uk':      ip => '10.54.182.112' }
  host { 'whitehall.production.alphagov.co.uk':         ip => '10.224.50.207' }
  host { 'whitehall-search.production.alphagov.co.uk':  ip => '10.224.50.207' }

  host { 'rds.cluster':         ip => '10.228.229.245' }
  host { 'puppet.cluster':      ip => '10.226.54.244' }

  host { 'frontend.cluster':    ip => '10.53.54.49' }
  host { 'frontend.cluster-1':  ip => '10.236.86.54' }
  host { 'frontend.cluster-2':  ip => '10.250.157.37' }

  host { 'backend.cluster':     ip => '10.54.182.112' }
  host { 'support.cluster':     ip => '10.57.9.177' }
  host { 'data.cluster':        ip => '10.59.3.162' }
  host { 'mysql.cluster':       ip => '10.59.3.162' }
  host { 'mongodb.cluster':     ip => '10.59.3.162' }
  host { 'monitoring.cluster':  ip => '10.58.86.95' }
  host { 'cache.cluster':       ip => '10.51.39.70' }
  host { 'router.cluster':      ip => '10.51.39.70' }
  host { 'graylog.cluster':     ip => '10.234.213.245' }
  host { 'whitehall.cluster':   ip => '10.224.50.207' }
}

class hosts::preview {
  host { 'rds.cluster':       ip => '10.229.38.255' }
  host { 'puppet.cluster':    ip => '10.224.103.67' }
  host { 'frontend.cluster':  ip => '10.58.253.150' }
  host { 'backend.cluster':   ip => '10.228.95.176' }
  host { 'support.cluster':   ip => '10.57.10.89' }
  host { 'data.cluster':      ip => '10.59.61.129' }
  host { 'mysql.cluster':     ip => '10.59.61.129' }
  host { 'mongodb.cluster':   ip => '10.59.61.129' }

  host { 'monitoring.cluster':  ip => '10.51.62.202' }
  host { 'cache.cluster':       ip => '10.58.175.43' }
  host { 'router.cluster':      ip => '10.58.175.43' }
  host { 'graylog.cluster':     ip => '10.228.175.48' }

  host { 'signonotron.preview.alphagov.co.uk':      ip => '10.228.95.176' }
  host { 'panopticon.preview.alphagov.co.uk':       ip => '10.228.95.176' }
  host { 'needotron.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'imminence.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'publisher.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'private-frontend.preview.alphagov.co.uk': ip => '10.228.95.176' }
  host { 'contactotron.preview.alphagov.co.uk':     ip => '10.228.95.176' }
  host { 'search.preview.alphagov.co.uk':           ip => '10.58.253.150' }
  host { 'planner.preview.alphagov.co.uk':          ip => '10.58.253.150' }
  host { 'calendars.preview.alphagov.co.uk':        ip => '10.58.253.150' }
  host { 'smartanswers.preview.alphagov.co.uk':     ip => '10.58.253.150' }
  host { 'frontend.preview.alphagov.co.uk':         ip => '10.58.253.150' }

  host { 'whitehall.preview.alphagov.co.uk':        ip => '10.49.105.155' }
  host { 'whitehall-search.preview.alphagov.co.uk': ip => '10.49.105.155' }
  host { 'whitehall.cluster':                       ip => '10.49.105.155' }
}

class hosts::ertp-preview {
  host { 'ertp-api':    ip => '10.239.86.141' }
  host { 'ertp-mongo':  ip => '10.236.89.222' }
}

class hosts::development {
  host { 'puppet.cluster':      ip => '127.0.0.1' }
  host { 'frontend.cluster':    ip => '127.0.0.1' }
  host { 'backend.cluster':     ip => '127.0.0.1' }
  host { 'support.cluster':     ip => '127.0.0.1' }
  host { 'data.cluster':        ip => '127.0.0.1' }
  host { 'mysql.cluster':       ip => '127.0.0.1' }
  host { 'mongodb.cluster':     ip => '127.0.0.1' }
  host { 'monitoring.cluster':  ip => '127.0.0.1' }
  host { 'cache.cluster':       ip => '127.0.0.1' }
  host { 'router.cluster':      ip => '127.0.0.1' }
  host { 'graylog.cluster':     ip => '127.0.0.1' }
  host { 'whitehall.cluster':   ip => '127.0.0.1' }

  host { 'static.dev.gov.uk':           ip => '127.0.0.1' }
  host { 'smartanswers.dev.gov.uk':     ip => '127.0.0.1' }
  host { 'publisher.dev.gov.uk':        ip => '127.0.0.1' }
  host { 'private-frontend.dev.gov.uk': ip => '127.0.0.1' }
  host { 'panopticon.dev.gov.uk':       ip => '127.0.0.1' }
  host { 'needotron.dev.gov.uk':        ip => '127.0.0.1' }
  host { 'imminence.dev.gov.uk':        ip => '127.0.0.1' }
  host { 'contactotron.dev.gov.uk':     ip => '127.0.0.1' }
  host { 'search.dev.gov.uk':           ip => '127.0.0.1' }
}
