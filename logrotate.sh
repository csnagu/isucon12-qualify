# mysql slow query
sudo rm /var/log/mysql/mysql-slow.log
sudo mysqladmin flush-logs -p
echo "slow query flush done."

# nginx access.log
sudo mv /var/log/nginx/{access.log,access.log.`date +%Y%m%d-%H%M%S`}
sudo nginx -s reopen
echo "nginx access.log rotate done."
