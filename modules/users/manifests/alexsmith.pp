# Create the alexsmith user
class users::alexsmith {
  govuk_user { 'alexsmith':
    fullname => 'Alex Smith',
    email    => 'alex.smith@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPnVeHa2j0uuoiUd4ffZ092o58xb8eKvRpm3WTWDJ2AkVP/YfPHOj3OH7U2SMYzfTbDKjsMEm3V+XtqlErg5vfENZXGRyALrbwUORCzSELENq+hxLyNmYs/kBFj+SEL2nZ7f3fYZ7b/9xvVli2hARytMZ8ltRTSUBhkuRA8MgSj18M7xF8PJ3tc1+Cm6yf5XpzPqVVM2mpI3xXWyC/Phkj0TWjoJZpjbd56qUyfOgBuLxM1ALUqRa3APTDocHgxDClyE+iPB1ZxyUXPkPq9Qie4OSAuwNs+j1vpMadZz9weBdYT7X34lclgfW+xRjluAuuid8qmZsh1VZTtPyMjchCSOiTGQgDBrBk3S0Wu7RbZ/AQqx3vY6S06JEe10hseeh3ltSoryYhOiiZmXuz8wbvsxhR3HYFd5oUUcLuxsRU1cnc+vjf+zLgWAl+WHIi0oN2ezRlgIYXCFYfhdMZNKnB5sPr4hkn/rnID+BkzQvpevzZy1BxWsPtcDXxydGVfm5XB05GMvXUou94opZKYMcTkNHFgMlEpW0ssKbFOUBsv3x7fidIkf7sDDT1couqvB8h+EzHbXmf5cN/5ybjuINqU6i2Vmd0BaiGCuf7EhfuKEvVOPyMqgi9QR47jLcAHrMD75f8RV1B5QrmOSX/O/+5frnVd2Rk2GDwLfsZdaLslw== alex.smith@digital.cabinet-office.gov.uk',
  }
}
