# Creates the matteograssotti user
class users::matteograssotti {
  govuk_user { 'matteograssotti':
    fullname => 'Matteo Grassotti',
    email    => 'matteo.grassotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDF1yCoNnJD+bAU252dhSqtJK+lxa23d2pTH7CBGoh8m61hnQ7POTj/zAhPYd1Nse83t1OW/n6Sd05GtbMAGhfvsaMOQmY3kHOd7LXicSX+zbwbu4xriE9CdkgvnD6VQkm9v8AjtujAFTx7umvfBeM8kNM5zgxjNORjyQaP6r/PABSnaapSFBWkF2J01j4Y9kXGVjUy/B4LP4UKNiNlyr6gHxZGkAFqIhzK5SGYM1a/A+ovaDXAJ9DUQeaiRvoKFHZrGrn7amH5C/7RGyWwHtuzAC+iI6fGDr0Df1O8TM+j/YZ5iROsfjCkEkf2uG4q/IkOhJHQhX20eQNRt5H1NTlgPQ39nfrFX/kNF/Z3eA3Y8ELWEvSFcBAIL6/fnlUHSNCDZ035hQK3t+8xL/WHmHEVpGGB8Cv3SH1GYPsA5UDSIEd9ILtbVjxGxKcScbjHrU6o1J4rV9s8MdUVxI0UXsnqFoXFp9zRVBzq/04RzZujma3i7XtssDze79NaHmC1kcPbkcTGh7e4A4dWdIs8ZQA2tjytG+t2Wc+/8gMUlMR7gYx7N/s9TBYGJ+ZKMclWuSALR2uS0z/aGlq4AwYdYavIZQFCJ+W0IyfSguG746Ue8O3S96anb851PkP17VfC9ODLOZKD+9RXljkOGiOzsHGW+dTUPdfOsBrPVUJpAq6ttw== matteo.grassotti@digital.cabinet-office.gov.uk',
  }
}
