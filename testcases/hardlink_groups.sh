#!/bin/bash
# Test hardlink groups
#
# See https://github.com/pauldreik/rdfind/issues/18


set -e
. "$(dirname "$0")/common_funcs.sh"

reset_teststate

mkdir -pv ${datadir}/{group1,group2/subdir}
echo this is the testcontent |tee $datadir/group1/a
cp -v $datadir/{group1/a,group2/a}
ln -v $datadir/group2/{a,subdir/a}

# Run rdfind. Running with "-makehardlinks group", which will fail for old versions, falling back to old version compatible "-makehardlinks true"
$rdfind -makehardlinks true -grouphardlinks true group1 group2 > /dev/null || $rdfind -makehardlinks true group1 group2 > /dev/null

cat results.txt

if [ ! group1/a -ef group2/a ]; then
  dbgecho "BIG ERROR! Not even old behavior works."
  exit 1
  
elif [ ! group1/a -ef group2/subdir/a ]; then
  dbgecho "ERROR! Verifying old behavior... "
  
  rdfind -makehardlinks true group1 group2 > /dev/null
  if [ ! group1/a -ef group2/subdir/a ]; then
    dbgecho "DOUBLE ERROR! Should not happen!"
    exit 2
  else
    dbgecho "Old behavior ok"
    exit 1
  fi
  
else
  dbgecho "test successful"
  exit 0
  
fi
