#create the vanitabarrett user
class users::vanitabarrett {
  govuk_user { 'vanitabarrett':
    fullname => 'Vanita Barrett',
    email    => 'vanita.barrett@digital.cabinet-office.gov.uk',
    ssh_key  => [
      ‘ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZ6qU9nwfNpsEnGFobMo6Pm/f8igB4u1iV+tDc59qzDD/3TFuTLcNt9IaMQAe3noxOoNJqmobYR6RDgN6c3CNquJkSWOYpFzMCX4UK7y8XRP2e2o9O1wiJoomDb+STR1oikWhHoqji7KCVu2zZ5N5+IzUiSJyFAV1WEHnwgJJ6clJJjaEkS5wdotX8q9z7QpMzvyBxtw8HOLMKyXAvpXTn2Zi76QNeGobygTWj4USCTZK7HyH057wETTa9s1yhFdrTcNr2V2eqjfaHQQYzReuh+lVDBfZW0SFT/Z0KNBqzr7/tpUczF0J96e6VJ/w4RKQxKxOGj+GnMP3olfI8W5PTicUZXt0J/QwMq6Z/TFAsaDKNS6G+WZWiFiK2sCp1UneK4z4Sl0T5dlM5NqRuPb/pwb4p71+YPzTQPpSyQa/2m/YGfhpIhK3ZSniRpOlpprdDBGkzxjWfZyisBtBAybcdR/IWj2iDBwwf2k6xyVZ8iD2cSAbjbboksQrCgxiv9RhjyhkUgq7LXbyiiG3tzGMyc1zN/MMT29QkAlxVoAxBbWArRn1vopRpu5+JMGddW0y40t1E92K72rkQ4nasQIogEWxvuMmhTWfGZPYiiB101BY5Y+0hGe9dBNkxHUY1oWEGFWwo5rFkKdKjHgGQA/hL6mm057Wn5sweWCpPZr2yyQ== vanita.barrett@digital.cabinet-office.gov.uk’,
    ],
  }
}

