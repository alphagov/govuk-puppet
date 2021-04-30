# Creates the thomasleese user
class users::thomasleese {
  govuk_user { 'thomasleese':
    fullname => 'Thomas Leese',
    email    => 'thomas.leese@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+yAH6zcra3p4fSsjayX9X7z37p/F7EnZPdko2VPeXZXbTeCmjvM8rnROKpnedHSN1JJ4H1IjnzN3PjiD1qm41vR78HwDY2NWXOfkDAMknvVSjjgeHcUOcpVLc+5o9rF6Q65GoY08AaumWEpLGeYAKYVYNGBQDBIukkcGqtP16IW+M0JsogI6pQDUt6BcIMOO7lfHoNIDaTIJNP/SOJ2yPwhNk0MkBp3evmXKyDpwsNxK5VOUr5l12E8XxEEhl5Ovs8TE5xfgDaURYiXtyPAakaIXm0dvH1uErozRIkmU2gi8rH3Ni57lUiu+4xEWcCzNy8+FvyGdYI14zAMX6sND+iIYJzxadbIToD3OJINuqtNfpzWh6+eJiwRQ9LjjcBS3RQ6n4O7Tgs08c0Yi9T6DuuiqDo+6rjDzUmtYmJWitRaNJJx1MA/o/E3WFEGK4sVs0jtor+ka6QHpIcecUI8VVwiY7PWg2XkbxF9i02z4JfohPwUDVP/ZAJXHVSlcrH2xWA4/L3e1oY2mx0mtEObBMClWd82XCX4V46zg3QFJPoPSM1wlTUMO5laTWn7UsZZFIPbqVPzSS4/+EamFBcX36tTIsnS8gifXd4wke+bF39DEaJh85U/vK1DgjTZsL7S6TlUvyi83uAORFfzl2k0Ho35OJKoBHNeHL4l0sumI4bQ== thomas.leese@digital.cabinet-office.gov.uk',
  }
}
