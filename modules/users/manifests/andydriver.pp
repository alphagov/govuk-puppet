# Creates the andydriver user
class users::andydriver {
  govuk_user { 'andydriver':
    fullname => 'Andy Driver',
    email    => 'andy.driver@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPVp4escReOGBiKil4wYDm/Gyw6nQjhHSHuytLsBC+RFdVv93MlhXPZmNvB6bcFIwWrykDNfm6fArnxnllB79NhpU/3SnB803kIYZxMl6uBkvC/oVdzNHizhTjho5u+A8D1OZ7sc5c8xLdq6VVjIVAAmrScyEDP4ZA64gtGANfove7ctHZ6WzH/BKl6gh4w6z5rRo1vKVxSEQFWRMh7XW3fXqc5BzaulHGs2D3ThzIC8/R6yAGXZH//nbr+8VK0oRHMGasGeTeXI4rW3lWFZqfnzTKIUo8m6HrYqYvRAYiM8vz4A4X5tIj8ymeTNK8bGNjLJlUGM87TONQR2ohv8JF andy@MacBook-Pro-4.local',
  }
}
