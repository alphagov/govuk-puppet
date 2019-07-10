# Creates the user chrisbanks for Chris Banks
class users::chrisbanks {
  govuk_user { 'chrisbanks':
    fullname => 'Chris Banks',
    email    => 'chris.banks@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSKBHLQPIcTA7zFFiPVVygVmSxFR9RTMsQhoyjPu5IHZbR4o47BYFxelLK4pT/JbLOTRT3smjD94YKgMoyN2NyJByXrSUiOY9IBrE3G786gLIszH+mWvLuRaxTuHrqU/OL2kndfrI8HF6f8x7Hea+8ustSgXjit9xgDaaXn2JArw1uUb70q/96/qhVOQl+zNK0JK0iYIZY1mTFBYXDT9py2EXdp4Qs2aWvBQCM4Hui9dxovmnsGa8VcXqUmozlQTAGgdnJkMYmUftViJB9h0P2QtO0Ooi4INcE06YEWDuZIo2ti/RFi4K6tzB72szABiutbqRlWXy8tLoLyFBYyY4kv06i71kevvyVNNbARWzM9VGWNYWP3SSx2mDDpYHzTKku+1g28zNi1SJhoHqI/qig5LwMZrVNte2ANGPjdN1KFjWVakzAYQyhjbTckK6lzvaxZNK+qsQPS3gzTl4eB6e/TsWl2Tflzud5bpidgOY4SoUWUBxNedvrm3xS2JB++LbnwECmY8wJqrNIjFKHiR9LId8E8RM02ZheX9Klt6Gr9pg/9XD6TQj9dFvNREP0FK34mC6DeZpDBuVgI27XlZmkJiEQs386ewYYB501m02W8dlh6wHF9UB1alzMWykIYYq7T1kEsWUdBOUrHx4/IZ4ZPoZSoHQlvl9NZj3gS2SgcQ== chris.banks@digital.cabinet-office.gov.uk',
    ],
  }
}
