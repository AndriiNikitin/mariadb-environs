# remove old repos if exist
rm -f /etc/yum.repos.d/MariaDB*.repo

# will try to clean yum cache to work around errors like below trying to download 10.1 after 10.0 (note incorrect url mixing both versions):
# Not using downloaded repomd.xml because it is older than what we have:
#  Current   : Mon Mar 13 21:07:18 2017
#  Downloaded: Wed Mar  8 04:05:40 2017
# http://yum.mariadb.org/10.0/centos7-amd64/rpms/MariaDB-10.1.22-centos7-x86_64-client.rpm: [Errno 14] HTTP Error 404 - Not Found
yum clean all