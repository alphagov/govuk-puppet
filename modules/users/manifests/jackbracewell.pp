# Class to create Jack Bracewell's user on GOV.UK
class users::jackbracewell {
  govuk::user { 'jackbracewell':
    fullname => 'Jack Bracewell',
    email    => 'jack.bracewell@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCjYe5j1hM+jBomhuSwdwhKpqLema15vVhjwdJ0vBAja9Q9NrCALRDNLIJYMf4qdRZA8u/u7uWC+w1k6+PNIpqRuom19IK6RZsCqJrj9fowTtYfuPxUcnMZve2tMr0E6RBFhaAuMpuJdfWieB099Oxf74U7uenPKh9VfxJSMFrKYOSNMHitunDp375HZxdY9hBfXqelQmBYYQ9Y/89XSrouXn+fGngcGjmyrSzq/v9z8JSjEUfDQF0+fVF32y7vdxaevLHAbRUw74xMhC17gj7DOOXthBjI7YrNBHETJKw2UKBbg0mgYTvHiBel+8qdKb44FyVes0GQXyo1ZYO56WX',
  }
}
