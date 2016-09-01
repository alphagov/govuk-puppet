# Creates the bevanloon user
class users::bevanloon {
  govuk_user { 'bevanloon':
    fullname => 'Bevan Loon',
    email    => 'bevan.loon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCub5yMv5Fd7WasvYGU1CZcRAkrqzn/fKXfTLGUs7dQCYaNOk+X5cfAHHzGthqKLmXtDBPZJGK4OnqkZyGTslFHWIMAo4zl+bQ2IvYimctaNs3vrnNqGu7yRm9u3SW8uKjH1ZuJDexjawiL6ZqnC9Luy3BeGJv506EWYh/Ckw4aJC6o3Km8IPvPGSBfSHzT1G5oF81DBKajCmBkBXUYkJCOJjFee0j68pYLJCepyO9tOCr3XsgHhRCeWci0hLYBYhdwf1fnJ2s08J9vi1gePFEiSOrJX2K1uznQrYWy9kMNIsN7TRi4wmxxms5E1NZqxfFDuLA9SzOVpErjt4L4bXwL bevanloon@gds3967.local',
  }
}
