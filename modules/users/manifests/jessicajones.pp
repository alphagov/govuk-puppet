# Creates the jessicajones user
class users::jessicajones {
  govuk_user { 'jessicajones':
    fullname => 'Jessica Jones',
    email    => 'jessica.jones@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDz1jQiUt0mysH71YyAFqRO94M+R+VOKAAeDTGy34+gFpccOnYYwpS5BXUnHVLXuT51oLgtTqVPNx4BH6eX27PfsS96hZtLtkrJqENnNpS//xwJtpjZ/eirGmWyvpkIwmFlFjjcX3bUq0HfhXyMxsNCSg571+P1OkBCqFq1bWVQzWV0DzvkIFOZXNM/TYnFTfrpJXBtgKCYdBQcBI8ohetmx288J6pUYqM9oj9LbMq+62uKQjRsunpIXQlSMztifdia+LypT518WQRUXxEjukcgaCJIvFbfpJxTojPS4nICPomMJr08gvDq3lmvW5U+XCTqQ1In5KH+5GKHzklLbfjK2eSPAAKWs/CitmQxoPYwbNQFpNpCmB+UioCXyzF3XOcGm1u7uP8ukIxSyogH2QQsHN2li4ZIVUlakkYfQSCljJr0+oyYEYbTZ1FztbAHmx1YikAgx8yi74cRKOpg2tX+EZPIruoP5WM/1XjjGkpuM8j8k0W54TeHkp9dd93VJL2ZQQcw0fbqxbQPFp+hCeEEQYKbxTB2BWVzVBPQnHNwMyUaNvJrC0COwcSlg/VibYzj6NkgpGl9ftC9nwBCTe6CvbZnHYGNE8WcFFLAcGTPf+yvIsMvURWAOltqA9qVlMZEWsHuLGBEFDJu3QoPInunoom5u4Rfd/FCWa99fa8ntQ== jessica.jones@digital.cabinet-office.gov.uk',
  }
}
