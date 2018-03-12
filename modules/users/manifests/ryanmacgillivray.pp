# Creates the ryanmacgillivray user
class users::ryanmacgillivray {
  govuk_user { 'ryanmacgillivray':
    ensure   => 'absent',
    fullname => 'Ryan MacGillivray',
    email    => 'ryan.macgillivray@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxOBUyLewa9eL3AyQdrlrw0w1q0hrry3AYGNp2kUQBJz8zF5Rho0A434YRSp3Y+NDzmS2E9HPrTe9Q0YaqFRE2+3bOsM4QwxcunPa06PDEIuO4k5IMrEW/NadF8/5PGRIH2cP0qQPTDpq94pfy4L+FTJ4Pku0nE5W+4S3Cq6uoHG24YIgBsnwK6QmKWTgu4oEcLXwo+/3VAMGnhMsk+gPMLqeCj5ZC4aKF4TrNxgFLZ85bd+FuZZlccszHV9/IOV2+dktld68QcbuPHYF1KDzs04FtICtYSQNuD2lP4WM8v/iDhywLz+kobf1xgOa2N7iY2UbVZ+KK2KMU7Cm1osYqM0xes9nfXMPZhSsI50Rov1SaY8GpkCAvUe3hDHTPfLlr/hABGAOBpPl1cUXfaQZuJL+Zy0eBDIxssE7uaCHL8QHexaE2B/CKCaPvxmmVXyexmYWmnSVdJcCXg/cEYcbHEvSq/yLrEVQaVUKSN6VCEwPJW+pf3dZGwRcewv0V/Y6Mu54x7G8QmQ1Vzm41we7FgePMab1oSHzh1J1JcgAh837Rdf5s5saciPW2Ap4hWKzPSQk5i2/Fp+Orf2r9yN54Ji0f/nv2eCuj8eJYnuji+DFG/I1th7v/S5Z75QDLsTnhQ/wcgbA866ZcNr+fSKkrvmDVPZHCecNWH4JqWUEE+Q== ryan.macgillivray@digital.cabinet-office.gov.uk',
  }
}
