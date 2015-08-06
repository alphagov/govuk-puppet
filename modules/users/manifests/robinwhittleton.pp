# Creates the robinwhittleton user
class users::robinwhittleton {
  govuk::user { 'robinwhittleton':
    fullname => 'Robin Whittleton',
    email    => 'robin.whittleton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEx2avJE08MNNFZnQtveLHdto1EdeVLTToSoSJW8rBHWkBm5lRPU6Ompzq3iKAiff0I9zw1L1o/cvjhe0o8vXh+7D5J2yZQ79KJjbqtbBQ6fO2Rh+pnR5b363PbM0lCXGlYYRdd2muag+zGxBc3ACOc8KGfJQ+AFLdU70ck5+jNZCtIUia+uhFxj185zrS310DIqZUmi6uOgrCqIqwd86W4BXoTwFuhRtXHuNCn+H2P4Yp7ybep7iEcgzKK7wZ0CtAxM8FLJ7zUVUMKplwiYYjP/33BNipF/+6I8mbJAX8du+RfKjR0Bu5OV+Q7XlPQJ+o0Ck8XN4pwtV7G9N4UC1Z',
  }
}
