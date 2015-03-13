# Creates the benilovj user
class users::benilovj {
  govuk::user { 'benilovj':
      fullname => 'Jake Benilov',
      email    => 'jake.benilov@digital.cabinet-office.gov.uk',
      ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPIo5R4UkyrgC9DHG1FucwrCXs3UjL1bWLzQtx/wbmx8JKSkVzW0Y5urMx3m087aHzin8ySc0oYltEVCPix0sBaHLH+QHL60yjohgRecmX//PGE0y4mVaB6e8ntLzv8vVApc1Uyz0PiaX2H1nbW6neWm0eagTr92gDvX4U5I2pTMC05qjXS09xFd/nPb4Z7G7BYLYiBa9yy1qkJvRyhKf3htOHGLoHwAgtJepKJMe1xTz8YOWHumcxn2e2j5Z16/wwcvaSGrhzwQgsZ2uWULWNvlKuC2nRJe+ZZjNcKxpHLKUcc68sW5yZgLHMJ7u0ebUX+rGWlMt6pyEiOBnm3nG3',
    }
}
