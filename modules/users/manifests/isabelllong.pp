# Creates the user isabelllong
class users::isabelllong {
  govuk_user { 'isabelllong':
    ensure   => absent,
    fullname => 'Isabell Long',
    email    => 'isabell.long@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLyZe/GffE/Qg0oimCf8EBj3YFOX1+uPdNAauFC4JfAebwCpDd/jaXRDmPSG0648GTgacn67BNsQv9j8FwkY9vKugW7XKc+4lRJXWUpAx5WRnvncLS24ObbtvPbXyN+n8M1gq7iXa4f94R2+wmHLdsn5eojwDhxej5Si7EzbDsUmnl7L2hmiFCrwYV5cGZxnXQGAcagFpQrIFBDhBf1Ft27ZrH05dbnRrnbokofJGbwgWNmOGu4CGLoDcfsFddwtZSoT0IljGZ2Qx3OlhmZpicl6dSmi2XjXHuS+y1eA16clxOzDp3N9tu1NKHezDzWVzOemH5k/JFpKL8qN392HtSVGyobhU+ziSrxeVlEp2AtIxoMy1Lrl8qb+6lOnoDQMYIZNZ4/C+Y2mkY94sfLp/CuofHiiCk6FsgChOP/Rvb1+JWoAXLay9Xl7p5a890lgJ9wYnVWGmPPuUl0SWl1jyLaa7F+ej6QuRuVyGDSpGCmmhGg5PL7H5OVdsZTSlvOnaZmHSCZtOVfGWpo0ho6IyaVNO5w3/CiOOSDId8oquOl7riRFcTaGlKj1yH7z8G6jKcd08ureJNP4fVITKmP1BCOARiUU8g+SR4uociT9vIo0kHIFhq7E7OXIT7zxixi2IXUfka+vHr9qVOAd1fcfdsFbcNj2AA2qSR4nYLXtAU2Q== cardno:000609852840',
  }
}
