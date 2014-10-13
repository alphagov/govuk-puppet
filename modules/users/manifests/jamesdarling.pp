# Creates the jamesdarling user
class users::jamesdarling {
  govuk::user { 'jamesdarling':
    fullname => 'James Darling',
    email    => 'james.darling@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuPNiu2qS5ApzkJAQ2p1fAYi8gTqZmH+Izg5zJewe/vdPg6lU9czkn5NYzIp2ZlT3VjxdJGASlKh/B1iMtJ82Ol6KTEG7A49M3JVoFTuWSxUnLVh/LUqjsegZT1rqc/Z1ujj0bEUbvFhZPLAuP9k7FdQJSkhoHFNYhxcO1uRXqPFWyLm2GaTU2oEhyrJ0K4coerkRzZqNDHzQrpDDbKIdxDJW/oYAncV5LucH9LFxLHg8d28tZwQw2+y1T9+JCLx8qiSKt7SX4S3cpY9rZiNHIRelrYFaEDwZ3wFrbQ5seI2uOxL3EQKPxQ1jiUg9kbGdM9J6FebHRDLyIxURpcY3v james@abscond.org',
  }
}
