# Creates the rossjones user
class users::rossjones {
  govuk_user { 'rossjones':
    ensure   => absent,
    fullname => 'Ross Jones',
    email    => 'ross.jones@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCnmN2H4rL5VjRA0Tl4y3v1OW3Zu6KXqmJ6VULwJ8w6xS2UJIumYZqtcqZgJqiZ5Ibq2kSao3fO8Yw8auD0I039OwwPqEnCazPidfoNktYc82/pkH0fQl68yHtMJmhXA4SETsaIVQqajFxsoZfoAUfkSo7p8OcEsmZ80Owx9JeJNgY7X6xKRqxqXpSc7O1uXnIqEmj3U5h4I/g2wF0pJkSnRO+PhW93aedv1rd9UYN1kUHT/Unmzd+pe9XRE7Ip/9wcLb+yYg6K7pziU6jfgHD6obyllHFV5IxHZJbxoBjJUYEsMGNzgH7DsxO7VAhJvRzqzMGztUUPMpi3XVSnoXXPvgsZxff34KLA30xJi0kFiBCrZI1T/sPn1BPB+Sp60QxEEwjYAYZeF+L9R/VhlVTDZry1c2Cw0TWA/UpeBuOLM1iTjKwcdHfpi+J/PrpmmDoKfSSRHiSB83xEuRdatbG9pYCekpulupPYNp/9etqR1KmF2KX1ojQ50N8S2QervWEGc5KxvOHbCGma7VaJKvMC09bPpRfl43mdwkWwlHSe8Itupdw0iW0PT7WPtHRSUzShJkjOzHN/Qp+wowNf5PBVPMmjMxqQaIfTddnMJ2hKvfEprkGNVw/L/a1cytFLuv1pNpZWXRLHaCCY/W7DFWx5LdyFEHqvsx5V+l2zP24sew== ross.jones@digital.cabinet-office.gov.uk',
    ],
  }
}
