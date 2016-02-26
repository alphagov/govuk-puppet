# Creates the andrewvos user
class users::andrewvos {
  govuk_user { 'andrewvos':
    fullname => 'Andrew Vos',
    email    => 'andrew.vos@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTYT3kzkFLwCFn+dKtfBU+BWpHy6kGYMlwzKJ4+jRN6upnatkZT6uhDxeg93pJn2KHpeWfmwshPM6FymCSDOjjAHYKyOY7/fg/jQk/tTJN6VIFJgBDTo2/imKxcjJBVckJBPqdvR76N0bkdzBalD3ABTPyiIhrqjqeH9YC6s3SF7jMJQV5DrlRVsiroDlOGJ0wQkIyhigeYvDYjVYEOxzEk2CubNF/A8QZW9Cee2C8zEbH3GKh+bHKOfsu5nj7jrkHjid1gA5J5IN/Icc+5VzQG6k5k/oNaQaCyZ75FYpTNpKbNklJHW+xABp54t6TnH7fFIoYeERZwICvSIit40vhrIBj3fQ/DqfcKje5FdtgtYMJ5TP8Tx+GNJv0A+DpYIvIhufi9S0uttLkJbRCQ0ylipG+GN/nKj05rXdRk+rT3mKYhC1L5XU5AEZsLiGOzJ64pSHuH5iJfac89pAJ2v7wfaBTTlsEoRgBCjSrgK3MF/IVr27XnQ7DDlrgAnocklC0keL2Gc4De9jkys1ndIVGCxxufVQRHAkPCoFaLSkxBBwNR783nDf7CZW6ZDkXPho5wkEZzeG73l65+2Mb7QY5mpfA9vdI2qMn/0bkPeshxBY6EFyjuTv8X22Jat7JJ0JXxQ0/fcqqing4fp7h4hAs2FQiKV3TMb1weFIzL2ULpw== andrew.vos@gmail.com',
  }
}
