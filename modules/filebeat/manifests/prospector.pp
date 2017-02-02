# Define: filebeat::prospector
#
# Based on https://github.com/pcfens/puppet-filebeat/blob/master/manifests/prospector.pp
define filebeat::prospector (
  $ensure                = present,
  $paths                 = [],
  $exclude_files         = [],
  $encoding              = 'plain',
  $input_type            = 'log',
  $fields                = {},
  $fields_under_root     = false,
  $ignore_older          = undef,
  $close_older           = undef,
  $doc_type              = 'log',
  $scan_frequency        = '10s',
  $harvester_buffer_size = 16384,
  $tail_files            = false,
  $backoff               = '1s',
  $max_backoff           = '10s',
  $backoff_factor        = 2,
  $close_inactive        = '5m',
  $close_renamed         = false,
  $close_removed         = true,
  $close_eof             = false,
  $clean_inactive        = 0,
  $clean_removed         = true,
  $close_timeout         = 0,
  $force_close_files     = false,
  $include_lines         = [],
  $exclude_lines         = [],
  $max_bytes             = '10485760',
  $multiline             = {},
  $json                  = {},
  $tags                  = [],
  $symlinks              = false,
) {

  validate_hash($fields, $multiline, $json)
  validate_array($paths, $exclude_files, $include_lines, $exclude_lines, $tags)
  validate_bool($tail_files, $close_renamed, $close_removed, $close_eof, $clean_removed, $symlinks)

  file { "filebeat-${name}":
    ensure  => $ensure,
    path    => "/etc/filebeat/conf.d/${name}.yml",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('filebeat/prospector.yml.erb'),
    notify  => Service['filebeat'],
  }

}
