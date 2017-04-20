#!/bin/bash
# this file is little mess for now and may need some effort to be nice
. common.sh || exit $?

[ $# -ge 1 ] || exit 1

# try to build xargs 4.6.0 as we currently rely on --process-slot-var option
function build_xargs()
{
  # if binary is built already - just exit
  [ -x "$(pwd)/findutils-4.6.0/xargs/xargs" ] && exit

  rm -rf ./findutils-4.6.0
  rm -rf ./findutils-4.6.0.tar.gz
  wget http://ftp.gnu.org/pub/gnu/findutils/findutils-4.6.0.tar.gz && \
    tar xzf findutils-4.6.0.tar.gz && \
    ( cd ./findutils-4.6.0 && ./configure && make )
}

echo "Checking prerequisites..."
xargs --help | grep -q process-slot-var || build_xargs >& /dev/null

[ -x $(pwd)/findutils-4.6.0/xargs/xargs ] && alias xargs=$(pwd)/findutils-4.6.0/xargs/xargs

shopt -s expand_aliases
shopt -u nullglob

if ! xargs --help | grep -q process-slot-var ; then
  echo "needs xargs 4.6 or later" 2>&1 
  exit 1
fi

start_time=$(date +%s)
CONCURRENCY=${ERN_TEST_CONCURRENCY:-5}
# this is currently doesn't work and is hardcoded below
TEST_TIMEOUT=${ERN_TEST_DEFAULT_TIMEOUT:-2100}

declare environs=""

for last; do 
  # build list of environs from input parameters
  # check if last is environment
  if [ ${#last} -eq 2 ] ; then
    for f in ./$last-*; do
      [ -d "$f" ] && environs="$environs $last"
    done

    f=$(ls ./${last}*/gen_cnf.sh 2>/dev/null)
    [ -x "$f" ] && . $f
    f=$(ls ./${last}*/set_alias.sh 2>/dev/null)
    [ -x "$f" ] && . $f
  fi
done

function runtest()
{
  local test=$3
  local testargs="${@:4}"
  local folder=$(dirname $test)
  local suitelogdir=$2
  local workerid=$1
  local test_start_time=$(date +%s)

function generate_logname()
{
  for var in "$@" ; do
    if [[ "$var" == *.sh ]] ; then
      var=$(basename "$var" .sh)
    else
      # skip environ arguments
      [ "${#var}" -eq 2 ] && [ -d $var* 2>/dev/null  ] && continue
      [ "${#var}" -ge 9 ] && var=${var:0:3}~${var: -5}
    fi
    res=$res$var
  done
  echo $res
}

  local logname=$(generate_logname ${test} ${testargs} )

  local logfile=$suitelogdir$logname.log
  local errfile=$suitelogdir$logname.err

# echo test=$test
# echo testargs=$testargs
# echo folder=$folder
# echo logname=$logname
# echo workerid=$workerid

  local pre="[$logname]"

#  [ -f "${f%.*}_scope.sh" ] && (. "${f%.*}_scope.sh" || continue)
  if [[ $test == *"_scope.sh" ]] ; then
    return
  # skip disabled and broken tests only in suites (i.e. run if it is single-script run)
  elif [ -f "${test%.*}.disabled" ] && [ ! -z "$suitelogdir" ] ; then
    echo "$pre" DISABLED
    [ ! -z "$suitelogdir" ] && echo "$pre" DISABLED >> "$suitelogdir"/_suite.log
    return
  elif [ -f "${test%.*}.broken" ] && [ ! -z "$suitelogdir" ] ; then 
    echo "$pre" BROKEN
    [ ! -z "$suitelogdir" ] && echo "$pre" BROKEN >> "$suitelogdir"/_suite.log
    return
  fi
 
  echo $(date +"%T") started $(basename $test) $testargs >> ${suitelogdir}w${workerid}.log

  for last; do
    [ -z "${last}" ] && continue
    local f=$(ls ./${last}*/set_alias.sh 2>/dev/null)
    [ -x "$f" ] && . $f
  done

  # this is workaround for xtrabackup tests which rely on this variable, should be moved into xtrabackup/runtest.sh
  export OUTFILE="$(pwd)/${errfile}"
  shopt -s expand_aliases

  # check if single file or whole suite
  if [ -z "$suitelogdir" ] ; then
    if [ "$test" == "${test%.*}.lst" ] ; then
      runsuite.sh $test 2>&1 | tee $errfile
      local -r res=${PIPESTATUS[0]}
    elif [ -x ./$folder/../runtest.sh ] ; then
      . ./$folder/../runtest.sh $test $workerid 2>&1 | tee $errfile
      local -r res=${PIPESTATUS[0]}
    else
      . $test $testargs $workerid 2>&1 | tee $errfile
      local -r res=${PIPESTATUS[0]}
    fi
  else
    # if this is another suite - run correnspondingly
    if [ "$test" == "${test%.*}.lst" ] ; then
      runsuite.sh $test 2>$errfile >$logfile &
    elif [ -x ./$folder/../runtest.sh ] ; then
      . ./$folder/../runtest.sh $test $workerid 2>$errfile >$logfile &
    else
      . $test $testargs $workerid 2>$errfile >$logfile &
    fi

    local -r runpid=$!    # Process Id of the previous running command
    local -r TMOUT=${TEST_TIMEOUT}
    # we check if $runpid may be killed and just exit if it has finished
    # sleeping in subshell reduces delay on job completion
    [ -z "$TMOUT" ] || [ -z "$workerid" ] || { for ((n=0;n<$TMOUT;n++)); do sleep 1; kill -0 ${runpid} >/dev/null 2>&1 || exit ; done ; echo $(date +"%T") timeout >> ${suitelogdir}w${workerid}.log ; kill -15 ${runpid}; } &

    wait $runpid
    local -r res=$?
  fi
  local seconds=0
  let seconds=($(date +%s)-test_start_time)
  echo $(date +"%T") finished with $res in $seconds >> ${suitelogdir}w${workerid}.log
  echo $(date +"%T") finished with $res in $seconds >> $logfile

  if [ $res -eq 0 ]; then
    echo "$pre ($seconds sec) " PASS
    [ ! -z "$suitelogdir" ] && echo "$pre ($seconds sec) " PASS >> "$suitelogdir"/_suite.log
  elif [ $res -eq 200 ]; then
    echo "$pre ($seconds sec) " SKIP 
    [ ! -z "$suitelogdir" ] && echo "$pre ($seconds sec) " SKIP >> "$suitelogdir"/_suite.log
  else
    echo "$pre ($seconds sec) (res $res)" FAIL
    [ ! -z "$suitelogdir" ] && echo "$pre ($seconds sec) (res $res)" FAIL  >> "$suitelogdir"/_suite.log
  fi

  if [ "$res" -ne 0 ] && [ "$res" -ne 200 ] && [ ! -z "$suitelogdir" ] ; then
    mkdir -p "$suitelogdir"/failures/
    cp -- "$logfile" "$errfile" "$suitelogdir"/failures/
    echo $test $testargs >> "$suitelogdir"/failures/retest.lst
  fi
  
  return $res
}

function config_exists()
{
  # this will overwrite $1
  set -- ./$1*/config_load
  [ ! -z "$1" ]
}

[ -z "$last" ] && exit 1

# check if single script nor .lst suite
if [ ! -d "$last" ] && [ "$last" != "${last%.*}.lst" ] ; then
  echo starting test $last
  if [ -f $(dirname $last)/_scope.sh ]; then
    # execute _scope.sh script with the latest environ which has config_folder
    for ((i=$#; i>0; i--)); do
      if config_exists ${!i} ; then
        . $(dirname $last)/_scope.sh ${!i}
        break
      fi
    done
  fi

  [ -f "${last%.*}_scope.sh" ] && { . "${last%.*}_scope.sh" || exit $?; }
  export -f runtest
# timeout is only for suites
#  export TEST_TIMEOUT
  bash -c "runtest '' '' $last $environs"
else
  if [ -f ./${last}/_scope.sh ]; then
    # execute _scope.sh script with the latest environ which has config_folder
    for ((i=$#; i>0; i--)); do
      if config_exists ${!i} ; then
        . ./${last}/_scope.sh ${!i}
        break
      fi
    done
  fi

  suitelogdir=log/$(basename "${last}")-$(date +'%y%m%d%H%M%S')/
  mkdir -p $suitelogdir

  echo "starting suite $last. Check $suitelogdir for logs"

  export -f runtest
  export TEST_TIMEOUT
  export SUITELOGDIR=$suitelogdir
  export ENVIRONS=$environs
  lstmask="${last}/*.lst"
  [ "$last" == "${last%.*}.lst" ] && lstmask=$last
  xargs -n1 -P${CONCURRENCY:-1} --process-slot-var=XARGS_SLOT -I {} \
    bash -c '{ runtest $XARGS_SLOT $SUITELOGDIR {} $ENVIRONS 2>>$SUITELOGDIR/w$XARGS_SLOT.log; }& wait $! ; (true)' < <(
      # test may be .sh files in directory
      find $last -name "*.sh" | sort
      # or .lst suite containing test commands, except those which call other suites
      grep -h . $lstmask 2>/dev/null | grep -v "^\#" 2>/dev/null | grep -v '\.lst';
  )
  testsresult=$?
  # now (if no tests were executed) run other suits which may be in $lstmask
  if ! grep -q -E 'PASS$|FAIL$|SKIP$|DISABLED$' "$suitelogdir"/_suite.log ; then
    # - iterate over all sub-suites (if any)
    for subsuite in $(grep -h . $lstmask 2>/dev/null | grep -v "^\#" 2>/dev/null | grep '\.lst'); do
      runtest '' $suitelogdir $subsuite &
      wait $!
    done
  fi

  # todo count failures / passes from _suite.log
  echo Host=$(hostname) >> "$suitelogdir"/_suite.log
  let seconds=($(date +%s)-start_time)
  echo Concurrency=${CONCURRENCY:-1} >> "$suitelogdir"/_suite.log
  echo Timeout=${TIMEOUT:-1} >> "$suitelogdir"/_suite.log
  echo Duration=$seconds >> "$suitelogdir"/_suite.log
  echo Duration=$seconds
  declare -r pass_count=$(grep -c 'PASS$' "$suitelogdir"/_suite.log)
  declare -r failure_count=$(grep -c 'FAIL$' "$suitelogdir"/_suite.log)
  echo Passes=$pass_count >> "$suitelogdir"/_suite.log
  echo Passes=$pass_count
  echo Failures=$failure_count >> "$suitelogdir"/_suite.log
  echo Failures=$failure_count
  ( exit $failure_count )
fi
