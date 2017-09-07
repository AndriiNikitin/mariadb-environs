# mariadb-environs
Generate scripts to deploy, configure and test your MariaDB-related cross-products, cross-features combinations

The main idea is that products may have different environs:
- built from source code
- downloaded tar version
- installed server binaries

Each product has 'code character':
- m - MariaDB
- o - Oracle MySQL
- x - Percona xtrabackup
...

Using conventions, user creates corresponding folders (environ), e.g. :

- m1-10.2/ git branch for MariaDB
- m2-10.2.6/ MariaDB tar distribution
- o1-5.7.18/ MySQL tar distribution
- x1-2.4.7 tar distribution for Xtrabackup

Now with corresponding plugin user can use the same approach for creating environs inside docker (choose any base image from dockerhub, just replace ':' with '~'):
- m1-10.2@ubuntu~16.04
- m2-10.2@centos~7

## Synopsis deploying MariaDB Server
```
# (some functionality below works only with plugins)
# install 10.0.29 , then upgrade to latest 10.0 , then upgrade to latest 10.1-enterprise
./replant.sh m1-system
m1-system/install.sh 10.0.29
m1-system/install.sh 10.0

# download and unpack tar 10.1.23
./replant.sh m2-10.1.23
m2-10.1.30/download.sh

# clone and build git branch 10.1
./replant.sh m3-10.1
m3-10.1/checkout.sh
m3-10.1/make_release.sh
m3-10.1/build.sh

# download and unpack tar build 14054 from hasky
./replant.sh m4-10.1~14054
m4-10.1~14054/download.sh

# download and unpack latest tar build from hasky for 10.1 branch
./replant.sh m5-10.1~latest
m5-10.1~latest/download.sh

# create another test datadir using installed binaries
./replant.sh m6-system2
m6-system2/install_db.sh
```

## Working with MariaDB Server environs
```
# then for every m* folder you can start / stop / configure / etc the same way
m2*/gen_cnf.sh
m2*/install_db.sh
m2*/startup.sh
m2*/load_sakila.sh
m2*/status.sh
# or use its config file
mysqladmin --defaults-file=m2*/my.cnf status
m2*/shutdown.sh
```
## Other related products
```
# enable xtrabackup plugin
./get_plugin.sh xtrabackup
# download tar xtrabackup
./replant.sh x1-2.3.6
x1-2.3.6/download.sh
# install xtrabackup from percona repo
./replant.sh x2-system
x2-system/install.sh 2.3.6
# now upgrade it to 2.3.7 from enterprise repo
x2-system/install.sh 2.3.7e

# download and unpack tar build oracle mysql
# enable plugin
./get_plugin.sh oracle-mysql
# generate scripts
./replant.sh o1-5.7.17
# download
o1-5.7.17/download.sh
./replant.sh o2-5.6.32
o2-5.6.32/download.sh
```
## Plugins
#### galera  https://github.com/AndriiNikitin/mariadb-environs-galera
Quickly setup local galera cluster

#### maxscale  https://github.com/AndriiNikitin/mariadb-environs-maxscale
Deploy maxscale and generate configuration files for galera or replication clusters

#### oracle-mysql  https://github.com/AndriiNikitin/mariadb-environs-oracle-mysql
Download/setup local MySQL Server

#### xtrabackup  https://github.com/AndriiNikitin/mariadb-environs-xtrabackup
Download/setup xtrabackup
Run xtrabackup .sh tests on MariaDB server (either with xtrabackup or mariabackup)

#### docker  https://github.com/AndriiNikitin/mariadb-environs-docker
Setup environs in docker images

#### spider  https://github.com/AndriiNikitin/mariadb-environs-xtrabackup
Quickly setup local spider cluster

#### travis  https://github.com/AndriiNikitin/mariadb-environs-travis
Submit build request to Travis-CI and get status later

#### hasky  https://github.com/AndriiNikitin/mariadb-environs-hasky
Download/setup environ from latest MariaDB labs build
