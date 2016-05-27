# Creates the mikaelallison user
class users::mikaelallison {
  govuk_user { 'mikaelallison':
    fullname => 'Mikael Allison',
    email    => 'mikael.allison@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6T5vb0lt6T8yhcAGr0d2VKlhN4r+f7K6cSITOp/3s9YPZSehhAKo65bdt3lSXo/NqB4xN9NJIn/zVMfDLLmSgLhmVLJe2d86HCQ8lW9m+nxZuHNamQYNxhpzK3H+3WD82Gu66rc+123SrQMA0rydCQJw0D69Z1C72S0ngsRhNwevA7ouTDu+dbOlioANa9fKskPmmXHQAM2FfgDCQui0m7LC6tCc9uj/FSsl2HtX0SxBxB2o9AC4b6cT0tR5DJfjR+/wJk+VJMHKnJKwKHY+1mUIY831UJ4P9X8+ykJJqtTbunRE/Z1eNTCBlDycvxK98YH+08MmDnMpHKEOoHkmp mikaela@MacBook-Pro.local',
  }
}
