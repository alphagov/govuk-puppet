class users::groups::freerange {

  govuk::user { 'jasoncale': ensure => absent }
  govuk::user { 'tomw':      ensure => absent }
  govuk::user { 'chrisroos': ensure => absent }
  govuk::user { 'jamesmead': ensure => absent }
  govuk::user { 'lazyatom':  ensure => absent }

}
