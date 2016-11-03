# == Class: govuk_mysql::server
#
# This is an abstraction for puppetlabs/mysql to enforce a set of sensible
# defaults and setup associated monitoring.
#
# === Parameters
#
# [*innodb_flush_log_at_trx_commit*]
#   Controls if the filesystem flushes after every transaction commit.
#   Do not set this to anything other than 1 (default) or 2, except in CI
#   otherwise you risk losing data.
#
class govuk_mysql::server (
  $root_password=undef,
  $tmp_table_size='128M',
  $max_heap_table_size='128M',
  $innodb_file_per_table=true,
  $key_buffer_size='16M',
  $query_cache_limit='1M',
  $query_cache_size='128M',
  $expire_log_days=3,
  $innodb_flush_log_at_trx_commit=1,
  $slow_query_log=false,
  $innodb_buffer_pool_size_proportion='0.25',
  ){

  $mysql_error_log = '/var/log/mysql/error.log'

  # The proportion of memory used by innodb_buffer_pool_size is configurable using hiera
  $innodb_buffer_pool_size = floor($::memorysize_mb * $innodb_buffer_pool_size_proportion * 1024 * 1024)

  # This preserves "default" behaviour and prevents us from needing to
  # restart mysqld. But relying on hostname isn't such a good thing.
  $pidfile = "/var/lib/mysql/${::hostname}.pid"

  $slow_query_log_value = $slow_query_log ? {
    true  => 'ON',
    false => 'OFF',
  }

  $slow_query_log_file = '/var/log/mysql/mysql-slow.log'
  $slow_query_logstream_file = $slow_query_log ? {
    true  => $slow_query_log_file,
    false => false,
  }

  $mysql_config = {
    'mysqld'                           => {
      'pid-file'                       => $pidfile,
      'bind-address'                   => '0.0.0.0',
      'server_id'                      => $::mysql_server_id,
      'innodb_file_per_table'          => $innodb_file_per_table,
      'innodb_buffer_pool_size'        => $innodb_buffer_pool_size,
      'key_buffer_size'                => $key_buffer_size,
      'max_connections'                => '400',
      'max_heap_table_size'            => $max_heap_table_size,
      'myisam_sort_buffer_size'        => '16M',
      'table_cache'                    => '4096',
      'thread_stack'                   => '192K',
      'tmp_table_size'                 => $tmp_table_size,
      'query_cache_size'               => $query_cache_size,
      'query_cache_limit'              => $query_cache_limit,
      'expire_logs_days'               => $expire_log_days,
      'innodb_flush_log_at_trx_commit' => $innodb_flush_log_at_trx_commit,
      'log-queries-not-using-indexes'  => true,
      'log_error'                      => $mysql_error_log,
      'slow_query_log'                 => $slow_query_log_value,
      'slow_query_log_file'            => $slow_query_log_file,
      'long_query_time'                => '1',
      'max_binlog_size'                => '100M',
      'sync_binlog'                    => '1',
    },
  }

  anchor { 'govuk_mysql::server::begin':
    notify => Class['mysql::server'];
  }

  class { 'mysql::server':
    root_password    => $root_password,
    override_options => $mysql_config,
    purge_conf_dir   => true,
    restart          => true,
  }

  class { 'mysql::server::account_security': }

  class { 'govuk_mysql::server::logging':
    error_log      => $mysql_error_log,
    slow_query_log => $slow_query_logstream_file,
  }

  class { 'govuk_mysql::server::debian_sys_maint': }

  class { 'govuk_mysql::server::firewall':
    require => Class['mysql::server'],
  }

  class { 'govuk_mysql::server::monitoring': }

  # Don't need to wait for monitoring class
  anchor { 'govuk_mysql::server::end':
    require => Class[
      'govuk_mysql::server::firewall',
      'mysql::server'
    ],
  }

}
