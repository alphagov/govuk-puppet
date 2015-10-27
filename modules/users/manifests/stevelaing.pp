# Creates the stevelaing user
class users::stevelaing {
  govuk::user { 'stevelaing':
    fullname => 'Steve Laing',
    email    => 'steve.laing@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeSLFvw+oskHAHa9dYzktJaYzILxJ0TeK9Op5uBmzFP5OChRLtbSseut1RIPGhNtsaeCI8xyO2ShmSGsIxJ6YDLEkMqVagRyUmJCiq7sFQuAK5J/q5zK/PlmqyVX+dIGiQ4oW1PzmFA/zAUx8nVlUWb+qDy2loj+7bnRg26VrIpNVTPm6XZfy1UIBia4y29mRF2ieLFWgGKB+xoQCrfgfU+RQi5ULOBuxS/OOfq8TeYzMUJdL17kTu9aVGQNm2OrdpKa9IKlMjYX5slC5WbV9+HS0RIpY5zf8CZFNUgjJnQ/HqYYgL0VyL41eQcCGKEnSTUKj5w4h851JUMpDVMW1D',
  }
}
