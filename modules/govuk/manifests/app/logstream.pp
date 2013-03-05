define govuk::app::logstream (
  $logfile,
  $tags = [],
) {
  include govuk::logstream

  $tag_string = join($tags, ' ')

  service { $title:
    ensure    => running,
    provider  => 'base',
    start     => "initctl start logstream LOG_FILE=${logfile} TAGS=\"${tag_string}\"",
    stop      => "initctl stop logstream LOG_FILE=${logfile}",
    status    => "initctl status logstream LOG_FILE=${logfile}",
    subscribe => Class['govuk::logstream'],
  }

}
