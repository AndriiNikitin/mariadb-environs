_testscript/upgrade.sh "5.5.50 5.5 10.0.28 10.0 10.1.19 10.1 10.2.4 10.2 10.3" 0

_testscript/upgrade.sh "innodb_page_size=4k"  "5.5.50 5.5 10.0.28 10.0 10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=8k"  "5.5.50 5.5 10.0.28 10.0 10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=32k" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=64k" "10.1.19 10.1 10.2.4 10.2 10.3" 0

_testscript/upgrade.sh "innodb_page_size=4k  configure_rest_encryption=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=8k  configure_rest_encryption=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=16k configure_rest_encryption=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=32k configure_rest_encryption=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=64k configure_rest_encryption=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0

_testscript/upgrade.sh "innodb_page_size=4k  configure_innodb_plugin=1" "5.5.50 5.5 10.0.28 10.0 10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=8k  configure_innodb_plugin=1" "5.5.50 5.5 10.0.28 10.0 10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=16k configure_innodb_plugin=1" "5.5.50 5.5 10.0.28 10.0 10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=32k configure_innodb_plugin=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=64k configure_innodb_plugin=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0

_testscript/upgrade.sh "innodb_page_size=4k  configure_rest_encryption=1 configure_innodb_plugin=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=8k  configure_rest_encryption=1 configure_innodb_plugin=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=16k configure_rest_encryption=1 configure_innodb_plugin=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=32k configure_rest_encryption=1 configure_innodb_plugin=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
_testscript/upgrade.sh "innodb_page_size=64k configure_rest_encryption=1 configure_innodb_plugin=1" "10.1.19 10.1 10.2.4 10.2 10.3" 0
