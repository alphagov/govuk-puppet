# Creates the digitalassurancetester2 user
class users::digitalassurancetester2 {
  govuk::user { 'digitalassurancetester2':
    fullname => 'digitalassurancetester2',
    email    => 'digitalassurancetester2@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdUEGMAev8IpADdxHUGx0HYbK/n+pQ7aEehJCGBgYqS5UKTufmRsgo2YecBtrQxIdDAXaIPWslpeNjOum/AE3KONp+0etQM9Jhh6gpsbmeH4d/2B/qE2YY62RVpdVCyPHXIexaYN42tSAxshvjzvP7vTgVeACKdEjSs/u9xfsqO8wlb2MA2GVLdPJfanXNTHcIBOnKrwrM4cmxMNgYgBthXk89BVOQBa9d7G9zHpIFXKsv/YPX3IFKRfTU0sBlVoHAy1UuWgy8mctsaOgR1k9LTsXMgW+GlkDjMAwIZ7J22A49fw8PeNsCaBq0UsNlAoismojEe/1LGJ913xucROrz',
  }
}
