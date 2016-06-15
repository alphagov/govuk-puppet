# Creates the russellbate user
class users::russellbate {
  govuk_user { 'russellbate':
    fullname => 'Russell Bate',
    email    => 'russell.bate@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5ARoIqWoJW9nVIGX4Em6TxhRSJ6udo9Eq1dB4ivoCmOZa8CRMMQUD7su78fLTkOnhM4hQtZELOK0hB9JyfGravLVMKhfH0vCmzuUiHGWSmlqMeKJQ34NQCrEqfTAOMbgmkyGLxMILlXR49YTfw3AOIHYhAi97eTT43PrnXbetixhc6VDOBnkYuRGPFszzYFyup+vBd0MTw7xW1x91NbtApz08z4pGwIjad//Sb69Xzle3GaTnaa/YRJCn5kcHXBi6r7XNYivbmF5FzxkAwnR8w73lE4348IPrBMqPAX25SQ6bordoBU18XNV5CmqW8dpNQ7MY8T4gqHgJ2Y+ckFsuPRH5r5FBAAsLBoyN/wjSWTNWisoaAf01Atn61UvPtZcoft3gqGlmTX6l/WO/D2+7DTNbJRNWHTStVDzk6kltPPCreXATWN1QDhgWbgZo2WkYVd+giW6J5AizywPgXaQKhdgw+qfiyfNXaM+RwyDBLRQ4d5iHtRaQdSgCxfcoo9igHH0IRdRK0LYYR+M5EokOJvVnCrfXhFaQ89cCR3DZgEW41E1dwiLuhh54pAlk+3ym9awPnZFWZhrWmCqxwRPUyJWBwTqF4Kkpp6C89SbHtKo1U9RHh/x+JmcOFFNEuSutA3e5283uDBYgFQ7oseq8zDr96d5rKhQhWI7Qmv9pCQ== russellbate@gds3902.local',
    ],
  }
}
