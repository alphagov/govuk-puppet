# Puppet Module: Audit

This module contains configurations for auditd, which helps to write
audit records to the disk in form of logs. One can looks at these logs
using ausearch and aureport utilities.

## Auditd Keys

To make search with ausearch and aureport easier, one can use the
following keys:-

    KEY                     Usage
    -----------------------------------------------------------------------
    auditlog                audit the audit logs
    auditconfig             audit the audit config /etc/audit/, /etc/libaudit.conf, /etc/audisp/
    specialfiles            mknod mknodat
    mount                   mount and umount
    time                    adjtimex, settimeofday, clock_settime
    stunnel                 stunnel
    cron                    All crontabs & cron configurations. (including root crontab)
    etcgroup                /etc/group, /etc/gshadow
    etcpasswd               /etc/passwd, /etc/shadow
    opasswd                 /etc/security/opasswd
    login                   /etc/login.defs, /etc/securetty, /var/log/faillog, /var/log/lastlog, /var/log/tallylog
    hosts                   /etc/hosts
    network                 /etc/networks/
    init                    /etc/inittab, /etc/init.d/, /etc/init/
    libpath                 /etc/ld.so.conf
    localtime               /etc/localtime
    sysctl                  /etc/sysctl.conf
    modprobe                /etc/modprobe.conf
    pam                     /etc/pam.d/, /etc/security/limits.conf, /etc/security/pam_env.conf, /etc/security/namespace.conf, /etc/security/namespace.init
    puppet_ssl              /etc/puppet/ssl
    mail                    /etc/aliases, /etc/postfix/
    sshd                    /etc/ssh/sshd_config
    hostname                sethostname
    etcissues               /etc/issue, /etc/issue.net
    rootcmd                 all root commands
    password_modification   /usr/bin/passwd
    group_modification      /usr/sbin/groupadd, /usr/sbin/groupmod, /usr/sbin/addgroup
    user_modifcation        /usr/sbin/useradd, /usr/sbin/usermod, /usr/sbin/adduser
    audit_tools             auditctl, auditd
    unauthedfileaccess      /etc/, /bin/, /sbin/, /usr/bin/, /usr/sbin/, /var/, /home/, /data/, /srv/
    priv_esc                privilege escalations

Example

    Usage: ausearch -k <key>
