# Creates the andrewvos user
class users::andrewvos {
  govuk::user { 'andrewvos':
    fullname => 'Andrew Vos',
    email    => 'andrew.vos@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1wSw12idZU0OtAgGU1OGisiWJ9fk5KGf6uqXsX/rPEs8tIEiAm1SyquYyZjvt1MTRmtubHbtFJYbead3QphOyT4qkICakUzjlrMauaiQI8M8W7R7C8Vof3XO/2wxmTrvLIIFYKgma8RjjSgkNTmWqTu6OtwUdELwyAkBJoqZt6dHMkcWqISsU4SqTQPquWuh49rLhc6k9ylbH4jGY+urjxkGl2vcrohE7jZ2J8R89l+T/or0TTTA1iEbbgAWa+ueRpzCW6K0heWe6gCQyTNtYAyYZWVBAzuE9PfBra3efy++xWhwfwvpECnhCv3eeFdAUbhQJFIie1TZvdAWdBDm5y2CjMrJ1E79EN/mMM8mcx/zn0z946qnXImIOLkjQGbZlBN4/gFYDuZC59+tj2hxUD/Xo1egmoVeEGBt2+e5XXOANg9ectmYHtuclObHTrmCxTeCgzI6DJiNdNq5yK8icCwlCu/Acw/cLQ/CY++BVFOvn1IwBg8werxu0MUW8I8IL9clgw4R5Q0rYtDyTvkVYLs69h5oFe51hKCOWxPAOkKLACW9Fa3rqBOiAWNm6n1oZhBSdGJinZh/U9T2bo+w0KWJGsu9HrKJNIbpL5AbrQsMhkt3tDnTK9W7cNNlU982zwcIK3FL84PfW5MWiypqE7CtPQmB9ol1Ij/Y6RzE3bw== andrew.vos@digital.cabinet-office.gov.uk',
  }
}
