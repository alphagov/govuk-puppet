define auditd::watch ($file) {
  concat::fragment {"auditd-watch-${title}":
    target  => '/etc/audit/audit.rules',
    content => "-w ${file} -k ${title}\n",
  }
}