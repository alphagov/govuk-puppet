# HACK: To transition from existing installs of MySQL.
# See `govuk_mysql::server::root_password`

Facter.add("mysql_old_install") do
  setcode do
    true if File.exists?('/var/lib/mysql/ibdata1') and !File.exists?('/root/.my.cnf')
  end
end
