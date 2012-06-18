class cron {
    service { cron:
        ensure => running,
        enable => true
    }
}