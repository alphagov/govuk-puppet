# define govuk_elasticsearch::snapshot
#
# [*s3_bucket]
#   The S3 bucket where the snapshots will be stored
#
# [*s3_region]
#   The AWS region for the S3 bucket. Defaults to eu-west-1.
#
# [*s3_path]
#   The folder path within the S3 bucket where the snapshots
#   will be stored
#
# [*index]
#   The ES index to backup
#
# [*http_port]
#   The port that ES runs on
#
# [*title*]
#   The $title or $name of the hiera hash should be the index name
#
# Hiera example:
# --------------
# govuk_elasticsearch::snapshot::indices:
#   kibana-int:
#     s3_bucket: 'jonauman-test2'
#     s3_path: 'elasticsearch'

define govuk_elasticsearch::snapshot (
  $s3_bucket = undef,
  $s3_region = 'eu-west',
  $s3_path = undef,
  $index = $title,
  $http_port = 9200,
  ){

  File {
    mode => '0755',
  }

  file { "/usr/local/bin/elasticsearch-create-repo-${index}":
    ensure  => present,
    content => template('govuk_elasticsearch/create_repo.sh.erb'),
  }

  file { "/usr/local/bin/elasticsearch-backup-${index}":
    ensure  => present,
    content => template('govuk_elasticsearch/backup_index.sh.erb'),
  }

  exec { "/usr/local/bin/elasticsearch-create-repo-${index}":
    require => File["/usr/local/bin/elasticsearch-create-repo-${index}"],
  }

  cron { "elasticsearch-backup-${index}":
    command => "/usr/local/bin/elasticsearch-backup-${index}",
    special => daily,
    require => File["/usr/local/bin/elasticsearch-backup-${index}"],
  }

}
