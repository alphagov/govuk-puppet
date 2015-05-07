# Creates the joshmyers user
class users::joshmyers {
  govuk::user { 'joshmyers':
    fullname => 'Josh Myers',
    email    => 'josh.myers@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeTQBwaWVnfdIektN4aAT4s3ZzOqqvC6ru4fnp85YizawjYXPOblzfBatUs4oQiDCbfIUTX9LqIR9qWb57VH3YVKSuJqdiRHiEO8MmlkFz0eQZDSCNnfXe41k+yJ3xAi+mAhK08xH6gY/psTJSG2l95fXLqVeCIgx8luc64BQYjA8xzYbBtnlDSQGQQbkU57QhpxnW/+EYQqUI4EDzKuIlNBCjtZuvNcdDavhBhLJjPD2xI2ddP7k7P30rLvh5kLUZjyuh00Bnh7/fu/AiSZzcpEVBn6ozDf//3XOWvZ4z1cVQjRkhrySoz1CET3J3hp6WHjG2vobRrTl3ReHZDKyD joshuajmyers@gmail.com',
  }
}
