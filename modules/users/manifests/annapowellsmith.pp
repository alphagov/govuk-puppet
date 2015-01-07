# Creates the annapowellsmith user
class users::annapowellsmith {
  govuk::user { 'annapowellsmith':
    fullname => 'Anna Powell-Smith',
    email    => 'anna.powell-smith@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVyRpGBL8wK26tlU1hgloZAmOQV+ljn7xjgFdmG3tmoikLyQ5KV3wqMkhXUW37ooHYDmD4ep3ITD8jmoto/WlPRXPpwJgbSQPBNGyUL+LEe2wNyg98SJBOam8UVhYn++zJ7W5SMaS0t/C+dNrtVpWGWOZszJ+RUhKIdP2FaxdRKc89651/ubWZSid446q18QrVrX++AgoO65fOJC7UYq5GDyguBiDJhEiR3QJeAtp/D7HicqcvoM6Buc3VNzILbUBW5//yIpjqWwklGCrrKRGJbQdmFUTEA/0ev6YUx3DkU+Xj/9G7HRRlG7H4hV85ZIxl4b34OnzmBTuKvKXhL4DV',
  }
}
