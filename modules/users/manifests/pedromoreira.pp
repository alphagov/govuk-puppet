# Creates the pedromoreira user
class users::pedromoreira {
  govuk::user { 'pedromoreira':
    fullname => 'Pedro Moreira',
    email    => 'pedro.moreira@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDWlW1A0JbtBLX7baOC4tjPk3Uv/o8/7Bl5n8TkleTogi/E8xVmOoXW4750By4YISjTpLJ+UMT+buFzHfOr15SwaPrl9KqxXV6id2RfRPB8aKVkdD3SJMrW64oqGbqdNtJOJKuQDEZTkJYf253no1ps5VirbG8BRF801p8l/cHrj1WSHceJa2zTuqAEGIyzoPAE3+Apos4Gv5HsNMMhBoZ3Ih71mws2ifVy4xwmzfrb74FyJrB1jl7JzU4XbCtm82ueSyvS72zo11fX6zjOVTV7gazpNG0mjs1GQn1urP2XkpmxXOredjdRCqKm1H+VcpFcZnhgswqPAAjY2aaMN3j pedro.moreira@unboxedconsulting.com
',
  }
}
