# Create the tomsabin user
class users::tomsabin {
  govuk_user { 'tomsabin':
    ensure   => absent,
    fullname => 'Tom Sabin',
    email    => 'tom.sabin@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDScIZI6H+z9Bnopt4HdlnWk5Hf9D+xhPXSvYw+fjLRojulil2iMq7+j00hZ3XbX9cyn4XeR6Ai2TvlRLgDE50XmrSmny4RT4p7FT9XS6Kk0b6gK6BVlGeocOu/BSTUlsh+HKW/Q5mNCpvrY+Jly+Cj5m4iuMqpftvHBuEoI7W1vZYuCyO0voCDhsB2dM22PjglF7ynEtAgokp1k3CgEKIvsSmIclCxVkYzfEmVriluvQZM94seRhXHsunxYDmFEkQNWpzxKgF2SYLSRFNjBmcim4FwyXJHz0pIAUGN3akfoTKA1QH/dpBUsgR78xY+pp7k52y9oi98GzphYeMJj9oV0b8uWl7y23NGjMqQ6UeUCfRFvXR+45gD/zfh8ED1ukKOLGTTT1YwpKSl26Qu3Ksp+V4vP9wk4hdzlrVbasuPjMYbFxDWwxuH5nDBGQZKDlf1AbazFGumtxtNFOb2+oasc0F8QNbGWSmDsseg0lu62qDpLsce9CZPcqpfOSGdBXsSZGca4BTl6sT9noc7pQdzRt7rVtbfhGrh6vOqoVevZoODlbBe8KbOt6gjy8CrebO90ldgQEghwwBJ5Gp+Yu6FJoQ7L82qja/m9cmaxW8/8uu+Dey0rW1BHIxO5K3eTY9R71DBli+iUq2fquaRFVm6wCBojPEtAJE0UK+HkFfSkQ== tom.sabin@digital.cabinet-office.gov.uk',
    ],
  }
}
