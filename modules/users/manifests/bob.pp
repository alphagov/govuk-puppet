# Creates the bob user
class users::bob {
  govuk::user { 'bob':
    fullname => 'bob walker',
    email    => 'bob.walker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDH0ujr2a/7I4QtdC0bPFgZRuUju6Z6MLFnqDUzGswLrzz0q93rbuwUmG4hlCKcKuw6iUvYx44OjtEgOT41AIzGsZfz48uaYFz2uYbKAO2LvJdXfoH2dKmOGUyMCACtbOCogPVjCSIBIfbgI/2ZRZUBN9PHeINGIRY+oPF7MYYZWfNibQi85ckYvJGX3iHTNFg2b/icS/8EU5dZA79/yCtW7c6f41hn8HUZDoUWVh5SGraWAT9J3HkTFQydbox+JWCAyuUE96tDD7D3txIXF4cB13oBL65oKLmSSPaCfRtUdji8zbANsg2rtwdEyrbh1SVjMtjZB+aD13lN6ik/NpM05aHP6jQW7YTZ5svQM7C6wrgd8mEbq9vDRjP1COxoUGZZB58BtCX+bKmWEeoLzWG+Na1YkZVvZ2z5PuiCn42TuuSEnlv5BBlMpzpuEXhUdWjhy30II4THoEcqwxKN+Uney9SEtfhYlpgd8uJWoVXp5N/us0+94CFiiyEX11B3r1JZlNfdtdtFLhbvcuUuIuSP6sxv0xTLPQJST0qMQCRmASo6GhF3/t/CZ9ruS+LklyirS6nv/b2v1z5Ttvzy3UVYFjehafoKLSvhZF4KY2o13Ut6E+YE0DG29vwKr3DJ4etl4V0acw4qP1oe9ShynhxdnHuLWx8ycIMy5uxLcPCR4Q==',
  }
}
