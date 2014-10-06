# Creates the patrickdavenport user
class users::patrickdavenport {
  govuk::user { 'patrickdavenport':
    fullname => 'Patrick Davenport',
    email    => 'patrick.davenport@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCw4EXE+mjCiEdcPDj1t06im8q6XmhHZlsZ9rGJel2HTuKIZqyNKzb9pLh9nNYMt9IIsICBoWhHnotnX5iAsxxoO0z/gDvEWWgS0TH2vPP/GvU7w2v/eY9oZLhUrVHlNmNKfhsTX94IdEekqlu0k1q8E3oBcnLhIPcpHwRhHINiluCxvFyjSy77AHD5CKAJPON1zIj8A5O5FucZMXUJlg/AVYpejCg3uWMX/r7R+aLWqWU2cc5xpD6gS6CdbvP5mZ//mW/HNh59tmktfIkYJpj40YlBIfbN8udV8+0480UsIEzmLyUpbgzS770t5/otRg7MAs/VZQItxGHi+DzJclyr patrick.davenport@unboxedconsulting.com',
  }
}
