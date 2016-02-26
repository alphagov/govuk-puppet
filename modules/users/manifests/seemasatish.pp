# Creates the ssatish user
class users::seemasatish {
  govuk_user { 'seemasatish':
    fullname => 'Seema Satish',
    email    => 'seema.satish@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAWfw6NUUuU8C7c8MuLGt0hRjWN3W4ov2wjJTSGr+bAxStqEoWCpOG0ZoiXb8/idtxPd6gEDtHZSLzX0BRow9JeKA3hXQPmsK0W5JguXs6JSSIIKesQHXXjusp1GyKGiNexBbpU4PykNVx3BoNPgktGKg9Yzz+fE+5DixqVczsnEyJ/OJytsblZKyzOmPpg1bW+bao/kbDI470DrgkcE9amtGcyxc9KAvGM64CzJt49/xIRdKBObx6X6gbRpOoA4CkbU6FA4eJIHk6+3QwZFjF+Sshh2kP9dhf15eS8aHDA6kdolUeArycOVKqwnJgunjcS1EJ2L8oMZ4rpf4tOF8jtoZw58mBGsrJsZvSu7yGGYDy7z8I4V+5feOWMbGH6b5oA0VgzzhkuSA2u2VoVAmSdr5Be1YyfjhrgdiQYA5UrKO8mvF8MmNFulKdgow+M9/zzEskcK6rWBGj8kxUxqImQK2556TV2Dvz6KTSaKggfEZJI/9Y/5DaRwqvzPX3XSYzRB5zHnnFDIqqoQO2UfyLw7PxZ0xaYlRMyQn9afphT5ChrFV5IRrWNK1eghe/1t6p+Zjk7hhWN2BhTWXR553zlrzHwEyNIYuPnN2431uBkhh7ATMYuTTEULsOXjDpi1PycN5Gc6jfaG9y6sh++OZK4E7K7yGEaDHoYrj7zEFoJw== ssatish@eussatish.local',
  }
}
