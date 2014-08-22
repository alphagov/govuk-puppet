# Creates the roc user
class users::roc {
  govuk::user { 'roc':
    fullname => 'Ralph Cowling',
    email    => 'ralph.cowling@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZEAxcu70/IbytBYrTh6jDsouuH8mjBlRPoq8e3eEWryQWe6+wevh/c29hiG1J1iRVYfUzxnVV2lIlxh3YOPG4TIwMFHS1rMpmR8j0VTbNw89Jf2O90X+wZa5ERlBRpXWhV98EMLWPMXmSTo7bXAdIZvNolAkw0GaIV9ozbZHV69hcXLxXFgO7KSp6J5ByYcqPwHASmZhfSLEYNSmD8JnwU0Z9lJl+YrlT9x0OrY79lCfSMIfCJ+l8+nMsNi7YrPEP6RrtCR3mStKmBVtiLukclxKTkx4nDxxuYThlZwVz90VBiRQHerK62EKmxky9Wrmx3KPT5dQDOCQ8gTmfTPOl',
  }
}
