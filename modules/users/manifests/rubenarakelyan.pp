# Creates the rubenarakelyan user
class users::rubenarakelyan {
  govuk_user { 'rubenarakelyan':
    fullname => 'Ruben Arakelyan',
    email    => 'ruben.arakelyan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD3JSv9usRcPrHN45MEMr26sT4zsplKvzVhA0XouyUX9EwRqDFsSUtB0XIQcBzjTYxhdk7hgDEc6K91mVwFs9yyM2bp81kN0uue71f4kPQ+q+TIt/k44oejn0UCLTzdG01cI4CACZamFuSE4Jwa1K5ppJCAjmtmRuzfJrWOAXdOzYrGAm2mcg2KM+rPnOgLMDBaLY1aC4RTxg/fRHRbTg4Ghdck4ZrjkWkZmvPhODCoXi10beFA3V+ogCIGl8q2y4nHb2/AZyjSspmg9i11vBLmbCBfHgJISNssEaTflIblQfCLMqEy6iQNRSmke7oyI8bh28XU/hV7RsRRhvLOCXJeBXl+P/teh0OwkjeBRr+x8GYEPZlSiS5Yty7PljhRASYR5hZew3OHk6AwL+gtYUUtkO21lw0gCNQUZ2tpdUmbz8bRI2XGcSgHeeoK3XuKllBUBERKvwA7848b9cEwF2joF5Yraj/QEgJruC6ohGplhQOP+9lmklFIlljZfkWOxSGppsyuSrbknxPZTZrXJRvud3haYE4uK7nj1WG+Bxgid0lq6DDN3becs7RGE3V3CssIhgDeOkRbG8gVJnrHPtF2LbslnoDuXfeWXyJOFzwYC1SmsrfD/o/93LXiecnb/Fcu+aP0A3qkaJnR/rNYDXP8+cld4eusJHjOxNMsLFrtPQ== ruben.arakelyan@digital.cabinet-office.gov.uk',
  }
}