# Creates the ianjames user
class users::ianjames {
  govuk_user { 'ianjames':
    fullname => 'Ian James',
    email    => 'ian.james@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuR5+UXkYz6K1RfH4ODdz1FI280hYc0dBKwhcok39/L2HT3Zq7rf5NtxTF+h0ap6gVo8ljR4L/A9KzAz9N1Q9SGWQmQBRc5jlJ1zw1g9g26LM1ebS/IG6Zsw//0z1ODtT3103lkjA4KLLuY54YFrrEG7ktnJ2et0s27WV1GKYFgQJWjWg9iaYnLVqM6kTtOGK+O7VqCkZExBakru3r3G3Nigoj4BLPYmSlLVQ2xaHIPFa4hviv9DbElsTLmkr2PpM6VIR8984PJHxI/XSn8J1hev60xx+HT+SLkbaHBXqcesMOFNINCVRb7540gQtFOwOyMSrvvbH/CLUCG15Aea5BhjLTi888lXb4jjH/+8I8W40iZD3Qd1R6ZpxyKouA/g/GBul4fy053c60UxSxjiAhW/kxcKRbD2M9IBHsiPeGLejBFSHb6PLMqRbESsx78jttdBKso2JIVnDMIsbN0VreOOg56y1O7m+tZzarl7SSnalNvBF0t59J5GG+ig/XLA4otduAF30tFodd1b93FGe+qzkBJcuod+jD54ZTiIWoyoU6jXi1QfJX+2WP7rMGbOwbqIRI0/ZtFxn099Ur0dld2i9YXm3TaSWrmyt13cMKKNswwEtbVSNi1yIRZuMIeGbKs8H4C/U6RHXlyKVpABxbMgLQM5tcA2PkMNCc8dCJ3w== ian.james@digital.cabinet-office.gov.uk',
  }
}
