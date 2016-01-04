# Creates the grahampengelly user
class users::grahampengelly {
  govuk::user { 'grahampengelly':
    fullname => 'Graham Pengelly',
    email    => 'graham.pengelly@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeaAti3fn4s57tUx8aM7A7OUt7GZ4Zdn6jtVyQJJwXPFGVpXHnf3tm5XBMv8mUuVa+lyBmKcveFUiCwdjjwAzl+gcJ2NYnmeBZiWQbUfcjERC0JS/WvVrGZwrzyD450JRmxWvSJK5Tjyq0MCQ96cjEQsyvZn88Y0iS/hmDnP5B/INPHn+8Ul9im77jn0SCx1MmXP7UPWe6Gn50xapDNIRaHUdpWu245nsOgefezEosWwcvhy7z7Yx9rfSgTo19Nlx5mqpEpcO0RZPUHJeiCrEMYUfvJxNSk/i7UlHxjtFZkGC75stn1k/jmgF8HNQFVw1bZTHSktP6ixP6Cjtc6ahf graham.pengelly@digital.cabinet-office.gov.uk',
  }
}
