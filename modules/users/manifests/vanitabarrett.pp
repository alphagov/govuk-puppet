create the vanitabarrett user
class users::vanitabarrett {
  govuk_user { 'vanitabarrett':
    fullname => 'Vanita Barrett',
    email    => 'vanita.barrett@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9OfueFAahSrT4POmdVNM9WC0CcbRDYCTlrwjjY0yq9MsFFrVvNP+nMq/ZidRsvA1CHAKAS9U1p4H2J/2A3SVDXwvqWdA+t8iwvdiHCWSjopfvHBFxl/4PtfBg9SXRY+C4izSN/D0ZYQMxUjPnjHnbRVzkEmpz+qBS65FrJuWjE46LzDNBUyu7bPtCrE0SNB0J1BK6qEFJWjM4cfdz82hjL25PTQ+f+dRF2doYFfxyIXuqTAac7VIfDBwGOKHwiYATG0D0ZX18Ri0YycPlIhGcbYwgtRzHF6EfgBaF9+LcloUat2mT8Q9e5XfUP715So2TgJWIOoyk0usC80sx9Gia4ErvYg7KAHTh2qvbU//9xwQsWzd1Sb87rlYJhKHGd4+H23gVjywOIPaDuZeGTLDULDocH9Eql/bvj65pOz/V6f64HDwiiJ5nwP/mBOcjQ1/D19xLNIcOhsi8ZhwuSlB1zLgEZ/XQN8/g4Mw+zOKzvD7bWineW3kTiXtLrwB6gtQLLnpdb1ynAzz7JpPiaFb0teAcYUQmF2SWSoejLosWPGkLtZHGdQ3uDe7KyIgwCyHsMcpU1bHXFQlho+K0iq1fo/qtzceHiasE3K7amveSxd+KQZrTTX/w9u4daszq65Lu+8+PK1/wEqP4GLivKPRs6lfUeci8I71+cB/OMI53ZQ== vanita.barrett@digital.cabinet-office.gov.uk',
    ],
  }
}

