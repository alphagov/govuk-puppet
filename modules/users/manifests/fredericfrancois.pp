# Creates the fredericfrancois user
class users::fredericfrancois {
  govuk_user { 'fredericfrancois':
    ensure   => absent,
    fullname => 'Frederic Francois',
    email    => 'frederic.francois@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEQ4764qpZhFOgwxtP6EcG5WMP/AyPr9d98I/qaXf89cnmBHU58iSmHrDtZw/NxpDjKQu6yITXkRLiAzUmn8H0o3NLixH1yohx4BY/MbPVZjefj9FcbNsTr3ilxj1c8ITrGa+J5Uxds0lj9bgS7LIQPXDdO3IwpEf+zyX0tRPknYk8gBWcoVZ1JOQAudLbHVxN8ySFfalIafy5QNukoTRHozxHdJfNn8AOglSIIINqJA0uYyTxTUZ/ZLAPHVTA8lFWgICfc6RM/ajhFLP62bRSn448t9+aOZYBlHUULPyqX/saD2QV1KtHNDb/o50QBFPobbfTxIYbG9oDan6Muoo638Lhcrr2dzJIoJ6qF9EeNTa1BK7sIRd5/UrHMknmIdRVegDmAco7RpK9s6O3KYZ+JNI2FtIifADyXfW+VfgI8nNrefo6O7O6lM40kACNW/GU72iaaU0bj/KWEDSyCfIotzcXs3dl7j0jTf3cLdEqh9DomrKhr8R2Z+sfg+QZgH1MXnyYrgj+2xdFkzRdJnpgocSq6h0Jh7B/w272DtjV0yZGWrsHavmNa/KEjTXcNC6hR+TfeJTTGgPJBDH70U8YY/Igyt/ooJRqV7Ofjf3r9ZtxcxyHib+2dSZOLEaa85t36GBaZ1EhVwo8824OD2ZQK2d4TS82IcHCFFxoIM7FWQ== frederic.francois@digital.cabinet-office.gov.uk',],
  }
}
