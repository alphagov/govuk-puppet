# Creates the timothymower user
class users::timothymower {
  govuk::user { 'timothymower':
    fullname => 'Timothy Mower',
    email    => 'timothy.mower@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsBA7wDUCqetqJQ2SZ9nt7HsWPMis7Nsu4MFreuwMv1pUr08h2Agqi1vm9t0A/h+wtvOtxXRL+o6sp2To3dOHXQSz7rZqxBOKT3PSlT6nMDqgOnolE2emT0+tbpr0ep89fT5IJn7TibT0V3j9Cxicnista8UQERopOtlKVA7854OJIV2FBp5wFgT8UrM7xNSuzU2s8s0x2BqqRugfJJyHydZvluH6MSSIgPq+2HdcinWxpdLIXzFetIIUxub5fV7KxZKhltj21xppGzWWRCcy62QWAGA6n72iLdF/Xn583tYAzbKZk0bwfjHM5taV9Nt8WTNgJ8lC3Vf8j/Lwwk0l7',
  }
}
