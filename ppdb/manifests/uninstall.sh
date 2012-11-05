#~/bin/bash
PASSWORD="r503N8FWw502I3L"
rm -rf /etc/puppet/passwords/*.pwd
rm -rf /etc/puppet/test_ppdb
rm -rf /var/log/puppet/test_ppdb.log
echo "DROP DATABASE test_mysql_db;DROP USER test_mysql_db@localhost;DROP USER test_mysql_user;DROP DATABASE test_mysql_runsql;" | mysql -f -uroot -p$PASSWORD
echo "DROP DATABASE test_postgresql_db;DROP USER test_postgresql_db;" | psql -Uroot postgres