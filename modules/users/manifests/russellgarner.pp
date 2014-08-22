# Creates the russellgarner user
class users::russellgarner {
  govuk::user { 'russellgarner':
    fullname => 'Russell Garner',
    email    => 'russell.garner@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAuoIglteQmEwL5/T3maYcomkZs44x1Rx/YRn31vMEuAaBHqYyD5mLUFMXQbCyFO6mZcjx+uOTOT6QhzIiKa8dJhAs5K/KFtjG/6vuwqFdC/Tpggvx6My/vDROsZVmPz4RFrd9XhoL2ybAXaHq6hfo+j112J/n+rkemqzmR/gz2TGFni9jSWG8fEzEkMwQR0iHZnGSFJI2UUR8trxyk32Pq3hkyEiA+XdipR/U8uPnBB2C3+Ms5NUaI8kFmQKYEumqU093dUD7iuekw3vA3elD8oR6UeDGcoRbMomT8oaatPtZl2rSw343M+tEQTC4VsUtcYAiK46sCxIsSjCI0+k2eQ== rgarner@zephyros-systems.co.uk',
  }
}
