# Creates the mattbostock user
class users::mathildathompson {
  govuk::user { 'mathildathompson':
    fullname => 'Mathilda Thompson',
    email    => 'mathilda.thompson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwYex6XQ0tcB0juUKlzzofVVYC0PDrpQURapN01e0vaRA2pr4MXJr2kJGTHLaHGrHJqI/Zim9c7ihoJJ+kL3mAL7aBuC0QdPsG7cqCWMQOmwJMps7OWcng83ToRUwmBH7QswUqELmHo4H5od7edad+5bl/ZWd3yT+BJSuIEYjBB+JyO+CDCpmr1cdVgQCc+Z0ZICgCr7cz+g9AGkrgRWGAVKieXCaApCMBdZZIqDIABJbyDov038+j3myAAqpD6JAPuZy6dbct4GEhPPU4tZcEXwyIDfHEmNaYBGmvXXVP7FTr4SQJUz+6WSCVIYxgCZB4/qYM/TGdRA7RznNh6z5KpxJBiJAiqG8KsZ+DalEdDwiXf2tAer1g8sjhoNr5MivzunztoGitWhB6UzEAjMVipLRQigKxWWo5ENLOESIrVZ54WHXAaQx5FbRuLJWQQOcg2lw9+nDsnN/T1kC5N+fgAujMgoYCLpOS1ZvDj6TjSaaTWKulj4J8eOjz4gHWzV5LY7x+hnb+HG9CsKpcQ04YScFWeYS2R8TsD735tR4F0Cr6TbNYRH54ZK0ws/UZNrrsxYZ+YnEjBnB/cTrp4TxXZHbWVTIw298Rx7s3u2E8DAUycSzZePB9Mea9oEruCPjTUJiipDQzbViKwVQ/VbkDKuucZwbXYlWrp2sYkpa54w== mthomps@thoughtworks.com
',
  }
}
