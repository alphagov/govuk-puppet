# Creates the douglasroper user
class users::douglasroper {
  govuk_user { 'douglasroper':
    fullname => 'Douglas Roper',
    email    => 'douglas.roper@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOjJLc85U9w4swreYxcqTZ2ic6C1vh3nTJa/VeDxdMeFrDcMCQRBw4zuL7o/TBe8B214h47G0/28tKx3G5X/rLHaU/Hb3Z7/ukUuthcv106WDMTjKmo+c5J4Tc4xyAiKP9sCvswN6mCHvACQecuTmrrLlCp8PSs2HmkMP5YqnFElUNFvZM8dD4BUaIG6ENpPKXXK9ql1mDA7N51vIGKe/0M/Uoh+ZNPcfjefnOC3RDiJSEfIh9vyVlElGU3v6uI1jLUzOHZnBpk7+S3MVXekmFYrMi7qwmd17198wKOHK0s8SOt8EssYmXsajFvJN+d512TnJbAH8ojFFZVnsZB9cF dougdroper@gmail.com',
  }
}
