# Creates the michaelpatrick user
class users::michaelpatrick {
  govuk::user { 'michaelpatrick':
    fullname => 'Michael Patrick',
    email    => 'michael.patrick@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlqUGccFwzUCMuhFcoWEnPnslvJt4qxADOXsWkc8bn9dYVjUXuQuoORXMYd/wZvQhln6KHEKJF2IUwMI8/CjsSGPUzkzGH2Ob6kOtbL7zJxJiBaKTPDEPx6XNtkocvVW1JcvkNaoI30blVFK4BOiyfvCQz4puWg8+Zi7dtX32v1rXrADQHN/ON958FWAUfdJ8VsAKpZTYEaAQSqx8xRY2uKnGBwSkQepf4g6GBtcGAGrE+Ee61XIQrwtYMIRYWG9zDyNDJ+1rraOEBYG0FMEtg6IlJVwsfskymnOH8P2Tnhx0cQA0oUak2LgLSJ3IxgPNbbW7SXgsI27DCFXlzF9Wn michael.patrick@digital.cabinet-office.gov.uk'
  }
}
