# Creates the chrislee user
class users::chrislee {
  govuk_user { 'chrislee':
    fullname => 'Chris Lee',
    email    => 'chris.lee@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5pVGoaEW+o/pO6Wi1Vuj0yfmyCXZ0aCpk7g6cU3qlv/5HoG9Fec89H0AydEPvGsCWcIS5cMRIxlPrn4dGNllhFIQJUJrd9aciSzoRXGWQtNNs6pOqgX8RtGMJkv2BrzcqYaon4yxU7FeVVJtwiT3Z61sziYwzf9SWHDAk5jpvelLNBRqpndUaGRLEIg8yLN8pU05gWly09ub8N0iphc/2QH38c4Qkeav8/QiIg0zyD96Tx1imFkml40CJCqTU3qsv2XJVR4lziyO0nUwUue3i1vyNArtg+OiY6UxWHFLyeTK0KLKBW+uWDmqeNOlXR6XI5CC9dh7e+jIxKvAvejC3FwSNwOVxrYSNu9gp9vn6Ux2ch2jC49a+lkPNBGhejl4cu+fVxUt9ywcHKMiSMvG7rFjsWH/9UI/cT0zqKOtTMhM/skU8ypjKCRW7FMdU6rkvoCOyA5iTA/YKkoiRTzAiDyTwTbGH15creJlLTlZ9ihPJ7I8Mfuw1RSM0g0iN6XbBevyOafA0vv7zw1ODZ/5OQvSfB4nza9eBC+IIP3UsAfB27NYLDm8/3waVmVK0cmXNIqkMbbJbmQW318x8oF3vBQTo5kmjlpoPB5xOqNeeRQ7APfRDgOPaWgrRE5hJQqn/oeRrj/ev+T/cySfGCaHsx3CmFzHSZN68ZyNv/dZ0aQ== chris.lee@digital.cabinet-office.gov.uk',
  }
}
