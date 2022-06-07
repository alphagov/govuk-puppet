# Creates the ashleyburnett user
class users::ashleyburnett {
  govuk_user { 'ashleyburnett':
    fullname => 'Ashley Burnett',
    email    => 'ashley.burnett@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIaNylA2HprW5Jr4L235+yiwZ5yAazWdFP0fJGTBK7Ad ashley.burnett@digital.cabinet-office.gov.uk',
  }
}

