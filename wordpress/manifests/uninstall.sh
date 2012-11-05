#puppet apply site_test_uninstall.pp
rm -rf /var/www/html/blog
rm -rf /etc/puppet/wordpress-test
echo "DROP DATABASE wp_test;DROP USER wp_test@localhost;" | /etc/puppet/mysql/bin/connect_root