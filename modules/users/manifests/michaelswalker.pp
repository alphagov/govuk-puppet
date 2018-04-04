# Creates the michaelswalker user
class users::michaelswalker {
  govuk_user { 'michaelswalker':
    fullname => 'Michael S Walker',
    email    => 'michael.s.walker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8NnRLwPpkvF6Xhm90XENNaxibPAihNyadrRJYgqRv0dxLGlKBWp2yEPwu0uz2WjqC+B+IOEgUyd3YoxTLEAeGELe7G03F/vmbuvQw+gTxtKTtEOQwT4JXZH2KEbxu+Y4U1HlJfsSOFDSNFoYoErdIK0vVDCEg19crkZ0V4ujJMn7kRAayZu4nOFZDtBhWGAhI/A+taq636QB+4IZED4EeTr7bn7JcA+WGFuvO/9fhuBlHdOeZCBhDTADb3tgWhISDvD7R1FEozDRpc4UlGqd3OA/ySCM+Ee0TflYfAQazRwGH+1uaRmXKCxVpmulIre2ITQBlgcv8Bm+mucFD1+o9/E+0Hgud1tdD7o0rw/EX+rTr2azB47MlTWfnvR1IhfQEsVIc2x2sMt3Om5fPjZmbPoX3idrbez62PbG+vF5eezD4BHBi08kaV430/jsr+y6GLLY9bqyOKZr08Tif6OV89+rebCSqs6Yx6f+hXPQJGOAFL1O1ro/g24MAnEX6zJax6wtE7IXo3D+jYNjmCuVmv3KPAYmW/tEdY2zT38a4dNC2yME+psibDz89iTN1AMvnkJnraLnNm1s8NyO+pn4b2UMqSbLPkzDksSgo1G+pYJgWzF5UB2Vph1uiRnRBLu6Bh4/TgnWs2bd+WHTGY44TYA7NRsdaU0FiG7ZQzO0xlQ== michael.s.walker@digital.cabinet-office.gov.uk',
  }
}
