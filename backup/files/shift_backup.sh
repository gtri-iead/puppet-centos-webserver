#!/bin/bash

DEBUG=0

function showHelp() {
echo "
Shift backup

Usage:
  shift_backup.sh --input-intervalL={current, daily, weekly, monthly, etc} --interval={current, daily, weekly, etc} -n={ backup number }  <--debug={1,0}>

In CWD, takes the oldest input interval folder and pushes it to the interval.0 folder, shifting existing internal.n folders forward one. Also, removes any interval.n that is higher than supplied n. Input interval may be a simple directory in the CWD.

A note on intervals directories:
interval.0 -> between 0 and 1 interval delay in backup
interval.1 -> between 1 and 2 intervals delay in backup
interval.n -> between n and n+1 intervals delay in backup

Examples

shift_backup --input-interval=current --interval=daily -n=3

  Copies the current directory to the newest daily backup. Ensures four actual backups: daily.0, daily.1, daily.2, daily.3 are present. This ensures there is always a backup at least 3 days old.

shift_backup --input-interval=daily --interval=weekly -n=2

  Shifts oldest daily backup to newest weekly backup. Ensures three actual backups: weekly.0, weekly.1 and weekly.2 are present. This ensures there is always a backup at least 2 weeks old

shift_backup --input-interval=weekly --interval=monthly -n=1

  Shifts oldest weekly backup to newest monthly backup. Ensures two actual backups: monthly.0 and monthly.1 are present. This ensures there is always a backup at least 1 month old
"
exit 1
}

REQUIRED_ARGS=('input-interval' 'interval' 'n')
OPTIONAL_ARGS=('debug')
# Build regex
TR=/usr/bin/tr
ARGS=( ${REQUIRED_ARGS[@]} ${OPTIONAL_ARGS} )
ARGS_REGEX=$(printf "|%s" ${ARGS[@]})
ARGS_REGEX=${ARGS_REGEX:1}
NAMED_OPTION_REGEX=$(printf "(--|-)(%s)=(.*)" $ARGS_REGEX)
# Transform named arguments into bash variables
for arg in $*
do
  if [[ $arg =~ $NAMED_OPTION_REGEX ]]; then
    VARNAME=$(echo $(echo ${BASH_REMATCH[2]} | $TR - _) | $TR [:lower:] [:upper:])
    EVAL=$VARNAME=${BASH_REMATCH[3]}
    eval $EVAL
    if [ $DEBUG -eq 1 ]; then
      echo $EVAL
    fi
  else
    echo "Unrecognized parameter: $arg" >&2
  fi
done
# Check for required args
for arg in ${REQUIRED_ARGS[@]}
do
  VARNAME=$(echo $(echo $arg | $TR - _) | $TR [:lower:] [:upper:])
  if [[ ! ${!VARNAME} && ${!VARNAME-_} ]]; then
    echo "Missing required parameter: $arg" >&2
    showHelp
  fi
done

function doit() {
  if [ $DEBUG -eq 1 ]; then
   echo $@
  else
    $@
  fi
}

function msg() {
  if [ $DEBUG -eq 1 ]; then
   echo $@
  fi
}

MV=/bin/mv
RM=/bin/rm
CP=/bin/cp
RSYNC=/usr/bin/rsync

function find_oldest() {
  OLDEST_N=-1
  OLDEST=$1
  # Find highest N (oldest) directory.N
  for f in $1.*
  do
    EXT=${f#*.}  # get N from the file extension
    if [[ $EXT =~ ^[0-9]+$ ]] ; then # only proceed if file extension is a number
      if [ $OLDEST_N -lt $EXT ] ; then # test if its the oldest we have seen
        OLDEST=$f
        OLDEST_N=$EXT
      fi
    fi
  done
}

#Find the oldest input interval
find_oldest $INPUT_INTERVAL
OLDEST_INPUT_INTERVAL=$OLDEST
msg "OLDEST_INPUT_INTERVAL=$OLDEST_INPUT_INTERVAL"


if [ ! -e $OLDEST_INPUT_INTERVAL ]; then
echo "Source $OLDEST_INPUT_INTERVAL does not exist..."
exit  
fi

#Find the oldest interval
find_oldest $INTERVAL
msg "HIGHEST_INTERVAL_N=$OLDEST_N"

# Shift existing backups to make room for interval.0
for ((i=$OLDEST_N, next=$OLDEST_N + 1;next > 0;i--,next--))
do
  if [ -e $INTERVAL.$i ]; then
    doit $MV $INTERVAL.$i $INTERVAL.$next
  fi
done

# Remove any backups past N
for f in $INTERVAL.*
do
  EXT=${f#*.}
  if [[ $EXT =~ ^[0-9]+$ ]] ; then # only proceed if file extension is a number
    if [ $EXT -gt $N ]; then
      doit $RM -rf $f
    fi
  fi
done

# If there is no interval.1 then no link dest
if [ -e $INTERVAL.1 ]; then
  # Set link dest based on whether inveral is absolute path
  if [ ${INTERVAL:0:1} == "/" ]; then
    LINK_DEST="--link-dest=$INTERVAL.1"
  else
    LINK_DEST="--link-dest=../$INTERVAL.1"
  fi
else
  LINK_DEST=""
fi

# Rsync interval.0 from source based on interval.1
doit $RSYNC -a --delete $LINK_DEST $OLDEST_INPUT_INTERVAL/ $INTERVAL.0/
# Update time/date on directory
touch --no-create $INTERVAL.0