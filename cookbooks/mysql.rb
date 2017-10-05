package 'mysql-server'
package 'libmysqlclient-dev'

execute 'mysql permission' do
  command <<-EOL
    chown mysql:mysql /var/log/mysqld.log
    chown -R mysql:mysql /var/lib/mysql
  EOL
end
