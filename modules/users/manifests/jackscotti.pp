# Creates the jackscotti user
class users::jackscotti {
  govuk::user { 'jackscotti':
    fullname => 'Jacopo Scotti',
    email    => 'jack.scotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDM6c9vC/Dg30QmDLNNXWnXH0lqxZ5WzjbUpR8V7A49EffWlE1aiRmaYD0EhFdd8HCD344OfyDkwBRrtouqlWNoGjCrcusrwDUH0L2x2/DzV6ejnnqXKxtGBya6/38aw3wWEykvDhl+f1ZGAHCTryEWH4tKyewclY6fkVpJty04P0gjZ9NafoSgCneJNhTiqbySWOxngV+fJBHlB8tqPOi4ZdoO2RecAOIEykuk0XuNHMSvl7N6ovVbGInhIBXOAy3qtMSPz4zy9TYFDNO25wiv3bouEBQyPEzLOmuj82aeKMtLCqfUAIFa3YbgYBw8WeN8pZtPLVSVdSXaut7kBGs3',
  }
}
