# Creates the alicebartlett user
class users::alicebartlett {
  govuk::user { 'alicebartlett':
    fullname => 'Alice Bartlett',
    email    => 'alice.bartlett@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCla9I4g2xJNcIvgcRbILaeZohyUMaM8rvOkJCrUh5dSIYLGke+vzFbPQjEpXTt36oWstFlV1BeghYl2a3sNX0ipiEJ5EuvOc4Xqc2zK1vMsXDIN8Pqg1u93g4n26Fc4mRqg7zkJs80SdgflCLnyaxAqcy13ta8LCZGzjXEoDGVPHLRJe3tBZInH5gzXcR3cw3UgUTMBfKe/uIXIJ12QWuU/1uJrS5hosSuDam679Aq6hot2+L4G2XDwZPLn6xkPMNwYXr0qLIBuoaAeq1n+0+XSipgp/QpSCO0hV301wuFlU12YFkqbkEAi/FKbUKLQr11KmKWJZE6wOr/E4a4ZX8b alicebartlett@GDS3509.local',
  }
}
