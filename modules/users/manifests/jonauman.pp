# Creates the jonauman user
class users::jonauman {
  govuk_user { 'jonauman':
    fullname => 'Jon Auman',
    email    => 'jon.auman@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGkx7oOf0eTAioke8zpBUELXo4gzjUYr/+XcsuuHEpj0JuUTybcj3ytnNFv5EZ7mpQwGNvKlrYAfnDrsyCVR626rB3IApHq+7z4uIyg/MxhhyFSNS16x1KqLhhkHpsEyNVuytuDuOK01Mi90jcSTJIUm225zuMwDKTNGsYjscTYP+7RNgCaL4kAzXihlHhvThEjESsY3Ch2PCdTinfZ6Nbx39tEhEu2rL3pcq+e9oaHIBZqeNA5hNZ6wUU4E+q4lfZeDq+3lXQKyDNqYKuTlmpp0tAgxWk1aC2VGWfH2cWMQRgpr29rgoAW+jSBGy9+Y/9m/uyJKY0bq/PN2+tM86J5rmmyglevSCS7Zi+YBdEFl0HvjLcsowX4zC7W3vEkKSdVCE1Xq4PdItIDihfBKh5Pf6bnY/dHa+ZQ4GQW9fkzuTeFyG1QAA+2axJtZuAwDqejSiJQ4dyEeJNzXowp69VoyQkQstLliWHZpnvGQ7pVOVOGf3DLS5QmjHTzKbXJDlVoxD0Ne6e9Q6Iuo1DJPqVLMeKLsQK8Pr/LejB9A8Sk/JjfYUi69onF2+5ul7re/QDAURAIQvv7ipc4IwSzJUO+lCDusN/n5reFxEpHSdXblAm4I+j0nn10XIfGtGiGA4ucKTaCbgeNJuiI68jGmFqubhpkK/UV0H/Oj2wsMHNMw== jon.auman@digital.cabinet-office.gov.uk',
  }
}
