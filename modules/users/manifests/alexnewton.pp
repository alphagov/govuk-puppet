# Creates the user alexnewton
class users::alexnewton {
  govuk_user { 'alexnewton':
    fullname => 'Alex Newton',
    email    => 'alex.newton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmT8G/JIFxV6aShpMUDWB6cWUDpThcKIWuE73HSz40CjQ6meCOY3CmsemlieVjFwTu984cA4oW2tobvD2AeZ+y6Joan1tDH+CxgCP/S7tS24Tc9h2byq+TBf12sG+iuZtMNx1SePET54FfFyYaXADemdZcWpVet0hShAWRQyvVCTcS/gwRq59HGoJCyMiJgHuN/PQWLSOmYk/q07Z8QCODP3xMGqj3qCi+awgvFy3/IVbXepKnUYskKYU5Dw6VaQnNoEoVJ54jCrzJc2t5vk1ZxwSQgb75Vzn82moHt9LZeYZtmTzBXgp71TGT38+fF0mNnq2NcPX11AFpnr3FR1sS+VL2LIHLqm2dYi7iExr1nGTijhoCKhDHTZDRHeh2vNUXUgLNsiOlsGseGBTXtF3AwuOj28WuYp7m2P5sL7QB1zx/G6hAEcFVOt4LKfUEVyI2emvbkCJiVG4R6I+OafDXLePxOB8yfsHrTdNEJfD52gZD50fbdgrxS1WEgwKNKJALvPcmji3KOaCaXTmGgoElrtU81IoUOyyhFj218rl2hIjMdbLMQZSKnF3SFKV4yzJjUxv0X6TRMDgxS6aZKSHqhJ8Qy105YZm1F44E9aSAjH57rSrdXDcM4OOOXJBupenbdFruCZqtfsGpHZG0Ddj3VTspNL2Uk0cV+Bx4/PFXgw== alex.newton@digital.cabinet-office.gov.uk',
  }
}
