# Creates the benjamineskola user
class users::benjamineskola {
  govuk_user { 'benjamineskola':
    fullname => 'Benjamin Eskola',
    email    => 'benjamin.eskola@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1rm00BZc21Im+BS0y5SrET88LuhGYgUf2nxOj37XtA5ionFKH8EKUyCKv+c2ZP4w0WmkvI/MFASpLlDRe8fpIfKz9hySH+eeGueeYge35kWuNW2uz/qn19XuXaTbpT4TgcT22eKzaSGPzqulk4OW+up5xCT/hC5bzhbVbg8mPM05XUZSKXeZyItcICyAkX/sjWtUxER6nJo8IepMWBnSrF2ZAFR1XtN/jJjYUPXU0iW3KQbWrgnOrsmvqZlSp24+6oy41g3UboCdfBZc+0xCtKCNrnj6n6WU1lkxtD4chaylHgBRgCijJrN7kvMKPbulgEl6+WqDayVMHZO+NhhoMNNfZJGefX8jOzECnvq5WjpUQBV/MmWsI/X4XGgKr9YT1dScqAzdhNg/M7AKGlpMJv9vK7yaC7XkXv2xKLVe4Ndp8myapfI34nvJeBrurP0GnSEQlPo5UgODRKmib8QzJfgpr+Q4XJ0TUNRKrRJwJ9R+K9rctDt8LMt78hwPF6J/lfO6Ppg4W0zlSejX0Jw3stZaTurypTpHNNmNjaHvH2nl2YVSP1JuRB89uK/8zE4Pwv1O1Lv8IRonun6fCh7uXy5yZHvCItn+SOJpojYc2YxRNa8TRWlTpEtpGt13CU7LGs1zJo3yBNITxs9eaqDn6XzS6cwzD+u8wA4thZqhPqw== benjamin.eskola@digital.cabinet-office.gov.uk',
  }
}
