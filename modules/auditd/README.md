# Puppet Module: Audit

This module contains configurations for auditd, which helps to write
audit records to the disk in form of logs. One can looks at these logs
using ausearch and aureport utilities.

## Auditd Keys

To make search with ausearch and aureport easier, one can use the
following keys:-

    KEY                     Usage
    -----------------------------------------------------------------------
    auditconfig             audit the audit config /etc/audit/, /etc/libaudit.conf, /etc/audisp/
    auditlog                audit the audit logs
    audit_tools             auditctl, auditd
    cron                    All crontabs & cron configurations. (including root crontab)
    etcgroup                /etc/group, /etc/gshadow
    etcissues               /etc/issue, /etc/issue.net
    etcpasswd               /etc/passwd, /etc/shadow
    group_modification      /usr/sbin/groupadd, /usr/sbin/groupmod, /usr/sbin/addgroup
    hostname                sethostname
    hosts                   /etc/hosts
    init                    /etc/inittab, /etc/init.d/, /etc/init/
    libpath                 /etc/ld.so.conf
    localtime               /etc/localtime
    login                   /etc/login.defs, /etc/securetty, /var/log/faillog, /var/log/lastlog, /var/log/tallylog
    mail                    /etc/aliases, /etc/postfix/
    modprobe                /etc/modprobe.conf
    mount                   mount and umount
    network                 /etc/networks/
    opasswd                 /etc/security/opasswd
    pam                     /etc/pam.d/, /etc/security/limits.conf, /etc/security/pam_env.conf, /etc/security/namespace.conf, /etc/security/namespace.init
    password_modification   /usr/bin/passwd
    power                   shutdown, poweroff, halt, reboot
    priv_esc                privilege escalations
    puppet_ssl              /etc/puppet/ssl
    rootcmd                 all root commands
    specialfiles            mknod mknodat
    sshd                    /etc/ssh/sshd_config
    stunnel                 stunnel
    sysctl                  /etc/sysctl.conf
    time                    adjtimex, settimeofday, clock_settime
    unauthedfileaccess      /etc/, /bin/, /sbin/, /usr/bin/, /usr/sbin/, /var/, /home/, /data/, /srv/
    user_modifcation        /usr/sbin/useradd, /usr/sbin/usermod, /usr/sbin/adduser

Example

    Usage: ausearch -k <key>
