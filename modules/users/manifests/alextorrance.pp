# Creates the alextorrance user
class users::alextorrance {
  govuk::user { 'alextorrance':
    fullname => 'Alex Torrance',
    email    => 'alex.torrance@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDk0OGmUnLhsPk7jgXBHy1KcV9xfuDbFvZYmCVCx53Op6Q1Za5ggr4ZK6UA0nP99HvniUeKgK8k2Kvc0po/zSj7H7LH57jbx4Ss6JqjF9gctIqXtG8t9kRaU+goed3I8xuRrLLCNhmIYCvh41z8RIih6hEQ30P0tlq8fmM4YUl1NOXRlC/VA87en02vZOjwNxgC313aEqfD8SHmCXMkC8ZiK9ZxGmM+txT6E4D4PgzBTvdNtggs7FIfYN6ELORF5tEGYJMjlBtNzBFGvvZz2jwP+p6fqkLdZvcEAnyZupR55aXOWwhMYmJl2pl+UGYqS7dIzCcAZ6Ud4P5zLuUVdSN5 alex.torrance@digital.cabinet-office.gov.uk',
  }
}
