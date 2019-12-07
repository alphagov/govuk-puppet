# Creates the alangabbianelli user
class users::alangabbianelli { govuk_user { 'alangabbianelli':
    ensure   => absent,
    fullname => 'Alan Gabbianelli',
    email    => 'alan.gabbianelli@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/PLGiZCLskAbsBk63J+33IBsf7faNIJqZlMHo0j6KyXGE4o30ltBZV9WQuSKycUaZplHU51ho2vy0fWJkhQ+LACHv5R3tqSrNYW2cg30ySawtUmBLkYn7apjjBuyU6ojKwnLk9I3/XnkDM64qbJro54a3S2ve58fgvZ+uaNrSoRxuv0IVquoi6gZwQNZG/hBOnpgyEThav2N6ydd5S3lS7fwUcCu9MbQx95vhvFxmakDeHIbU+LbYExe34cEepEIjAzXPehvUpn6UiTHYoMx8caq0ogSsDgAgg3xxIk+jjlTTs0QgVDcGN4mjq/IhuWlAn5bceAbIY0f3/vkMYc+9joPdsaK+Lzsoj5hzgxfNRgbszSkDRAi+e7XJeTRcI2QLfDvxgBkKs/abuODMfKPtSEZ3jM8HpgxxHkIgEKfyGK405aYtX3uqj5cdPcnkb9Oa7DMUiBSPW2aZ2u3Mkv/S5cqFRrOkhJFWs95taUCWOOlf75VB+Gz0WsCjBG0oize/LVqfcVa8HG5CoeSW1T/uyjbR6Dfno0cmLI7Lj4ftoDUi3i0gKPZ9+W/zVSvPnhhXwfIx9bP1Fi1UKJcgGqqmC2M5XEcWchPdVySAeLZ3u4VGak/EU230gUGTHQEPhvY8eaEGntIfOoHdnLDJgwLrMgzxPgJNphw+i6WRwT/28Q== alan.gabbianelli@digital.cabinet-office.gov.uk',
  }
}
