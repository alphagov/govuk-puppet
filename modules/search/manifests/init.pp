class search {

  file { "/etc/cron.hourly/reindex_search":
       content => template('search/search.sh'),
       ensure  => present,
       owner   => 'root',
       group   => 'root',
       mode    => '655',
  }

}
