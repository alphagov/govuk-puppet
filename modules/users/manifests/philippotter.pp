# Creates the philippotter user
class users::philippotter {
  govuk_user { 'philippotter':
    ensure   => absent,
    fullname => 'Philip Potter',
    email    => 'philip.potter@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqeyaq8RyZuh+qoowqLbpTg3yktxZV8xHavBqXtnhJCL6J4CXVMlLZRPLnMqdxlT50+VQJxKUKDPZ1XEnGceAqF+tF4m6JMSkcRob7fkVbxDFloPPEi/2WI+Sq9SLEswmH/6X5Ih3ndPFaJEvKA6EKG/AHFOCERJ9VeFu7iXWtIoUcBvy19On9Aq7PNo4GRbaknW4XZWicylaLZ7GNuy1cssndF48yTp1rDB287dvwsaWXQYSwri0wDN3cFS6EfiJ7rRIlK9C5estHRCQAzKbNnMUTBnw+sy6WPeQKKe4TfpqAeveGVvOVfkdEG43EzkcnlKdi8mveUBEnlJtlh48l1egs09V3ZEy8M0IJszfQexk1uG74d0hEPHC0W1iGHckaO8o7ZGcB1qAPbj7t1HGIDPH9vcJ82p9IbfE5gjSLlHwkX0NclDXX1YKkSuOTUh851HGOoW2upc2EWEiTFYj9unEiirpTbc9jq2qh+YOQ2nvIweZSFKIvfcbKQTj4HeBKLO2LSFNJkviYJKB8LfDlPcFfAWkN504RagdDOwphz2rPAnN01BKJhhJ9UMmuxa+c3YTevjGKw8mF7A5w1il4ybGE5RJ3feNS2d7qswDVkY6K7b7CEaXoXNmfSl+3hW+dCMIE++fJfiUhO00bn1FtmargkCvQx2Fnal0ogQXnww== philip.potter@digital.cabinet-office.gov.uk',
    ],
  }
}
