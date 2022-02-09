# Creates the michaelswalker user
class users::michaelswalker {
  govuk_user { 'michaelswalker':
    ensure   => absent,
    fullname => 'Michael S Walker',
    email    => 'michael.s.walker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPL2bzX+d309Skj7zBhGajBYsl4+7KI5yo2xS9w8LJlSlTIm8Tbo/XZpG+Spu5sHt1K+n6T6Sver0wOcIovwO/nmHHg10QjHTCh82+i/Y6vNw8/LgBCehviSVWGdChI/VPpu30poAB3n40P/fNDc2QeNW8IieGCzEkwkWxyAz8cpx9QWU5oXTW4wwM53LXosZOViQNMsEDFwTv/OnzVY/jbueutLhN2Fku6/itsCut8qMoSVv+deX7Z7tIsWvTD3++1v4c6Wdt16Dlq/M4Wbvqoyku9eKrAUm5egb8ZjN1LSxp9vRqVTyrzNCzI4nown3hSVppl1AUQeAZp259hV08HS8dnkEqYcdiJLjXPcCkkKRkYMADj4TwZ2K/02Hmzq0ZeSauLmtcWQJkdJCOKO/5QlqHHm193zCJHHP/yJmkDeFR+9i4EFYkn9GyHao8H93vGLPGq/1IjLMF9zLRuIPxAJiZtK6JYmiqBb7HP3Mv4iEqOLgKDsVCk+zXshrMlwPoqKE5jDJ+RURlw+leAPdd5Ns4E7D070aVFb7x86nLiII1rbcEMOiknnQsI4fAi8stw65YOPeqQwlknKWLRDU65+FrKwo4GDHybwq7KZt2dpalsHADUjNSAPHci23XyGVPXnqHaeYwQuSC9sQcsuOGzsEOZldp1Bzz3xcLfyzKrQ== michaelwalker@GDS10881',
  }
}
