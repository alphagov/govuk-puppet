# Creates oscarwyatt user
class users::oscarwyatt {
  govuk_user { 'oscarwyatt':
    fullname => 'Oscar Wyatt',
    email    => 'oscar.wyatt@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRnpXveFLpYZYLP7RtHpREJmY6lSYzUM38vcCAgDAA/x4PQce+40KI9JBNTtTsU7nLmPSZw/DpC5gekiNOujFnDgZDE/ugDdIxJeA4ohA388gEXAB8P9sk0SGw/CgtIbyjOXxvh4RyQfCgGMYhJdQcGn4eFp0U4if1PP+IGQViU2On6+U92qIgMlhz0BS/Nrs0Ci27hQmyYJAOBJ4nmL4FLsOEPzzznkd+zz5i7/zLd1haN/COyN4lzrZLQ+KaW9re5DaiaFIV3t7iFywbo/2xNsp1ZB3k8gVC+kF/1sQbLoep2hdm4Vs3L5wxgDxrAs0Aj1/DvyRNNwh6bGz9iLjIGb1uZh3EB6Pf780KEBwiOnOY/trrMtOW3O3vhvZD2RwQr1nITkr54dPGI8RhREAcwJ1qpnuK7a8LeZ+liGJrt2chYHFlag+kT1Bp1vsLNX5N0ejSl6VIO2y2piNBClwYlbMNZ4oJjvO3RpEn0g8wNLHJ61zbb0+5hR6u4yWqkzeZ2i+9vlvV0SJLk8J62I/nlLFhBgwyNMyc0rkwl7NGhoD2ZEFLNP8Y2EB0cY/CY7qviEnrUf4qLFtVdB12WxmetPWbBNwAcO1DglIqqduaswFP4GtT8522xEFNtUGbfdF+odjBlGmBeO4mb/JZNvRkYt25LdH01Qr19t9fuuekYw== oscar.wyatt@digital.cabinet-office.gov.uk',
  }
}
