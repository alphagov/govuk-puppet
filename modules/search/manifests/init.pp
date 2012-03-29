class search {
  file { '/etc/cron.hourly/reindex_search':
    ensure  => present,
    content => template('search/search.sh'),
    owner   => 'root',
    group   => 'root',
    mode    => '0655',
  }
}
