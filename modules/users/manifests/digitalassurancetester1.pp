# Creates the digitalassurancetester1 user
class users::digitalassurancetester1 {
  govuk::user { 'digitalassurancetester1':
    fullname => 'digitalassurancetester1',
    email    => 'digitalassurancetester1@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Vc+LgvYzRPGTrQqaBv1UbwD65SHu4d/n/tUxNzkMAZzKT2xKSp8EpF8NxJXLLWlRwFw2x3P/6fX/M8nnKi4WY/U9lSwfkiSa3lxYbaqghrj/YGm45SAl9TOWlSv++frY3Cl9R9X/9gbAug9c2cgEhS+TPKzVGCEk4ScMRcTjEb3uUK4jV66Le95cx5qmB0rtmnKy8yaIsKaUnBQQzPVs92VM2CI/aWBBaJ7rRNaGBXCZPWRZMh4twO6Gd159vIxTHZIpzeBF/HryWGQe331V3nGKGQXpU2qPjdckF1GXNwDaJyFQ+UymVzngUEKrwZ8TDEvv4sHzk4sD8219gwDx',
  }
}
