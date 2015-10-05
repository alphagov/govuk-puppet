# Creates the chrispatuzzo user
class users::chrispatuzzo {
  govuk::user { 'chrispatuzzo':
    fullname => 'Chris Patuzzo',
    email    => 'chris.patuzzo@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2FtXGq+04/ZLtrsWwAI6j4SrIhUtriMwci1LMtYdLMt8BHue49BofRCNTC8BylatnMvIaGz62mKnddgo233zZDVozB8WeVCmsR4HqD1n86J2k4KCPk6wb6u3xkbylozj6wF8Z214tulEvv+PYv7RYRjBa6rsrgrD5PB6hO7jjuxUHwcBgl2fJJZRmUwaJMH8CZkMU4sLSlsdaM80PGrBm2hYLgRq5yxwf0B11jBlFfvLhAIi4hymwBinbxsTMOj0cq7HJm+HjU6avHObVkxTD54teZ/UR4mWWlcSTvWyvODlAdBzDEcVxclu39itSOQlpnFejV5kPuQPBVrGac1gRQ== Chris Patuzzo',
  }
}
