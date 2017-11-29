#!/bin/bash
# declare -r ERN_PLUGINS=""
# this is base port number used by non-system environs
declare -i -r ERN_MARIADB_BASE_PORT=3306
# number of concurrent tests and default test timeout in ./runsuite.sh
declare -i -r ERN_TEST_CONCURRENCY=10
declare -i -r ERN_TEST_DEFAULT_TIMEOUT=300
# your personal token from Enterprise my_portal
declare -r ERN_ENTERPRISE_TOKEN=xxxx-xxxx
# these profiles in _template folders will be planted
declare -r ERN_PLUGINS="galera docker enterprise configure replication xtrabackup oracle-mysql sakila hasky maxscale cluster spider myrocks git-worktree"
# use these flags when compiling from source
declare -r ERN_M_CMAKE_FLAGS="-DWITH_LIBARCHIVE=ON -DPLUGIN_TOKUDB=NO"

# exclude these directories when unpack server tar archive
# mysql-test takes too long to unpack so we are skipping it by default
# declare -r ERN_M_TAR_EXTRA_FLAGS="--exclude='mysql-test'"
declare -r ERN_M_TAR_EXTRA_FLAGS=""

declare -r ERN_CONTAINER_PREFIX=t

# try to determine free size of /dev/shm
avail_shm_size=$(df /dev/shm -k --output=avail 2>/dev/null | tail -n1)
if [ ! -z $avail_shm_size ] && [[ $avail_shm_size =~ ^[0-9]+$ ]] && [ $avail_shm_size -ge 10000000 ] ; then
  declare -r ERN_VARDIR=/dev/shm
else
  declare -r ERN_VARDIR=$(pwd)
fi

# hash from pwd; may be used to resolve conflicts (tbd if required)
# declare -r ERN_PWD_HASH=$(echo -n $(pwd) | md5sum | head -c 4)

# Retries a command on failure.
# $1 - the max number of attempts
# $2... - the command to run
function retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1

    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            echo "Attempt $attempt_num failed! Trying again in $attempt_num seconds..."
            sleep $(( attempt_num++ ))
        fi
    done
}


# prints amd64 or returns an error
function detect_amd64() {
  ARCH=$(uname -m)
  case $ARCH in 
    x86_64) echo amd64 ;;
    *) return 1;;
  esac
}

# prints x86_64 or returns an error
function detect_x86() {
  ARCH=$(uname -m)
  case $ARCH in 
    x86_64) echo x86_64 ;;
    *) return 1;;
  esac
}



# returns centos or debian or ubuntu
function detect_distname() {

  local distname=$(cat /etc/centos-release 2>/dev/null)
  [[ $distname =~ (CentOS (Linux )?release )([1-9])(\.)([0-9])(.*) ]] && distname="centos"
  [ -z "$distname" ] && grep -qi centos /etc/redhat-release 2>/dev/null && distname=centos

  [ -z "$distname" ] && [ Fedora == "$(cat /etc/*release | grep "^ID=fedora" | head -n1 2>/dev/null)" ] && distname=fedora
  [ -z "$distname" ] && [ opensuse == "$(cat /etc/*release | grep "^ID=opensuse" | head -n1 2>/dev/null)" ] && distname=opensuse

  # now try to detect debian
  if [ -z "$distname" ] ; then 
    distname=$(cat /etc/*release 2>/dev/null | grep "^ID=" | head -n1 2>/dev/null)
    distname=${distname#ID=}
  fi

  [ -z "$distname" ] && [[ "$(cat /etc/*issue 2>/dev/null)" =~ Debian* ]] && distname=debian

  echo -n $distname
}

function detect_distcode() {
  # jessie
  local distcode=$(cat /etc/*release | grep "^DISTRIB_CODENAME=" | head -n1 2>/dev/null)

  [ -z "$distcode" ] && [ Fedora == "$(cat /etc/*release | grep "^ID=fedora" | head -n1 2>/dev/null)" ] && distcode=fedora
  [ -z "$distcode" ] && [ opensuse == "$(cat /etc/*release | grep "^ID=opensuse" | head -n1 2>/dev/null)" ] && distcode=opensuse

  if [ ! -z "$distcode" ] ; then
    distcode=${distcode#DISTRIB_CODENAME=}
  else
    # VERSION="7 (wheezy)"
    distcode=$(cat /etc/*release | grep "^VERSION=" 2>/dev/null)
    distcode=${distcode#VERSION=}
    # remove these characters
    distcode=${distcode//[0-9\. \"\(\)]/}
  fi

  [ -z "$distcode" ] && [[ "$(cat /etc/*issue 2>/dev/null)" =~ Debian*6* ]] && distcode=squeeze

  echo -n $distcode
}


function detect_distver() {
  local -r distname=$(detect_distname)
  local distver
  if [ "$distname" == debian ] || [ "$distname" == ubuntu ] ; then
    distver=$(cat /etc/*release | grep "^VERSION_ID=" | head -n1 2>/dev/null)
    distver=${distver#VERSION_ID=}

  elif [ "$distname" == ubuntu ] ; then
    distver=$(cat /etc/*release | grep -oP "^VERSION_ID=\K.*")
  elif [ "$distname" == fedora ] ; then
    distver=$(cat /etc/*release | grep -oP "^VERSION_ID=\K.*")
  elif [ "$distname" == opensuse ] ; then
    distver=$(cat /etc/*release | grep -oP "^VERSION = \K.*")
    # 42.2 => 42
    distver=${distver%%.*}
  elif [ "$distname" == centos ] ; then
    [[ $(cat /etc/centos-release 2>/dev/null) =~ (CentOS (Linux )?release )([1-9])(\.)([0-9])(.*) ]] && distver="${BASH_REMATCH[3]}"
    [ -z "$distver" ] && grep -qi centos /etc/redhat-release 2>/dev/null && distver=5
    [ -z "$distver" ] && return 1
  else
     return 1
  fi

  [ -z "$distver" ] && [[ "$(cat /etc/*issue 2>/dev/null)" =~ Debian*6* ]] && distver=6

  # remove eventual quoting
  distver=${distver//\"} 

  echo -n $distver
}

function detect_distnameN() {
  detect_distname && detect_distver
}


# prints yum or apt
function detect_yum() {
  case $(detect_distname) in 
    opensuse) echo zypp ;;
    debian) echo apt;;
    ubuntu) echo apt;;
    *) echo yum;;
  esac
}

# checks if this is windows
function detect_windows() {
  local -r uname_s=$(expr substr $(uname -s) 1 5)
  [ "$uname_s" == MINGW ] || [ "$uname_s" == MSYS_ ]
}
