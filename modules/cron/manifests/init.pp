# Class: cron
#
# Purge unmanaged cron entries! This only checks root's crontab. Any cron
# entries created by hand without a preceding `Puppet Name:` comment will
# cause Puppet to raise the error:
#
#     Failed to generate additional resources using 'generate': Title or
#     name must be provided
#
class cron {
  resources { 'cron':
    purge => true,
  }

  service { 'cron':
    ensure => running,
  }
}
