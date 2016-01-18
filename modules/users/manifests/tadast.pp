# Creates the tadast user
class users::tadast {
  govuk::user { 'tadast':
    fullname => 'Tadas Tamosauskas',
    email    => 'tadas.tamosauskas@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/SkSIBNgl8wIn3lie8IX9rX/GG3NFVUyjAFfz40BikV46oTz9YjqLX5s6rW6lewvYkNsEwx8CWzeNMLq4oEgdV9huMLum76GomdY1c0mP1AspIon6U5HcInra1Yit/2uO72SnqKzh8DHbTb4zrvFbxMIHkEFDFu6MEXrst/Ddv6/esM4mV+wu1+JODu5Bx6hQNv32SpCxmTgeU9pR2bRo3tNf5mY+LVUnvY6cNGz7LLIxlx9RsUpwQQh+Q/zchJDzWCPUahf/1Dn8qnr9LYEs8/PK/Tx2frzjhR6hR0zArmD0ryTChGqgnsGzwj5X2z8lXJczoZCePtvsLw8tTWI+eo0PgMbxd8NGPnIkCN+mP5lrv5RNLCIJ+8g0X/aA62hP4ripfGRkf0C3YDl1hnNEhidPkrpIFoEQk0qdth31NujQTfDDuSR8T+qlJjKksH0D3tS21/l5t67Oj/a1735j7sC52IdEvfRTXaAGM90xpOTg27YvkXLiwLpoeF0x9ymuwp4pwjia995YLVYMHSgWjEvJa8li15ChdtxCuChL6J5IBWa73z0CWLu+SKPgT4ScKUCRaCAMOmbvUXlKSouMzAHC6tCOCclAj6SqtIMlhgM72Bd+vv5TiNx5jsVLp8vhhZl5Ygnu55uEX6jMVTVJwkx0S322j36Vj9zn8QglQQ==',
  }
}
