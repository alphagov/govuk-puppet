# Creates the daivaughan user
class users::daivaughan {
  govuk_user { 'daivaughan':
    fullname => 'Dai Vaughan',
    email    => 'dai.vaughan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2UL9m1ukdh0gZUoBOuGfNL9aZJ64gGa0Wn94a3owZxvfFHpb0cuuYb2EvyOt4tjpaKucAXRs+2nW+892p+wbwSerf26V6q8MgM0LbsDcXOkI8dqhx/HBZ9W6d3xpBdF/f1W3sKrKVvaVCZC6CrRplaPdDwPr/N9FF/qf4mRO5gCN7cP530F6uJnPj7tUKdIrkgWY8CMxhpF6uEFZTRdRJPUsKratS2k0w7woF09TqMngJuIfu+OFDJTm3VnIbn3zdgqJSWIO9RQFHOBg9SCSotNWetQfcaS4f8WJJy6/IFir0i05izy1f6PQPIxI9SbgiERp2G7UaOGtBGRePGluFxYnrZZxfRqlg41FeCeH2mKn/EKdwOSY/9gzWN4QQKKNPNaCoJxKo4QCI1225HPQgGfHH8V2fHgRf3lsgwWsnQUOWZi2KvjwTyO+qPNyj5sxVSt7o2B1l41bh7COqivc9MVvl7SqQK1VARQtoyLwxjjlG+Xgo2OfNB2OqCxn5UuSJpI6fQYhOFM3LYeSixVpK3t9WBqCi9bKEOx0lO1tzcXyES4rZDZNjyvJ3W0C6OkisMIeCArvQ+vI/d5FaUUhHeATS8C5Awe7/joq5OOn46hMDa93RW7WRrH5m5JddlraK3Pa6S1GvuTtpMZTSg32bXIK9zq+kmhhLjCQRU3yJAQ== dafydd.vaughan@digital.cabinet-office.gov.uk',
  }
}
