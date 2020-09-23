# Creates tirathrai user
class users::tirathrai {
  govuk_user { 'tirathrai':
    fullname => 'Tirath Rai',
    email    => 'tirath.rai@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwNNLA9GKjyQgfCjR1WdcWlfhftvNnOBu/3bfs3BI+K3G30mRfiPNK55zIEr/zb2Hs4micmitXV/bZuT+QxSAsQKAhd8u3Xm7g8dgvitKnSv8hqApu3X5FHWzsVRDhheP4nZkPSzgRVAgqXtfhYu8kZx7GEZyUGajM/BitZcMimPrNQ1f0XGEsrKj2riPKmsnYG0gkPxewrbuEg0j9r6VlvVouX6l4h1aVkyMXLitRN6wMm1jcBHtOGNnO4B0RINimYO4xJsmHNy3bYLCFPRa32eV3zETF8pDwly0Wjpwlj5tQ8oHHlhisLZNn1El1eNt+7PPbA4ZmY4Da0S7Wu7OasOsS9KDR5RqJtXgXDs+E3SMWibMBrGwS9Rn6OHCcfdg6jXPyon5KlkNAWy0vKHycMBxDkY1fAjT5/u5CwrMOcubTaPmyX9a/XG/IYe+jqwdfEGxZ/IARbtJkNUOh9WgsYsz6cERsrDm4gqLqzv+1MhrCZMJ5g29/99pY1CW9lu1eco1/TDRUcshCnnU8syt4pFv4R8aIV2QVAX/neGraknpUPskpjY+MnNcPTY3CzqBEX8dfIvULuP4SyCyxtnARyhtqNPojmLxaHOgvbNnYleTagMsj12YglmXlM8+xn2L4sFqw+vfewgJ/xoHTakb2mmPpUftT7Mxmy75jmVgHhQ==',
  }
}
