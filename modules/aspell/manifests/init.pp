class aspell {
  # For generating spelling suggestions
  package { ['aspell', 'aspell-en', 'libaspell-dev']:
    ensure => installed,
  }
}
