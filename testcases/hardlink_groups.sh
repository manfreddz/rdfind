#!/bin/bash
# Test hardlink groups
#
# See https://github.com/pauldreik/rdfind/issues/18


set -e
. "$(dirname "$0")/common_funcs.sh"


reset_teststate

mkdir -p ${datadir}/{group1,group2/subdir}
echo this is the testcontent > $datadir/group1/a
cp $datadir/{group1/a,group2/a}
ln $datadir/group2/{a,subdir/a}

# Run rdfind
$rdfind -makehardlinks true group1 group2 > /dev/null

cat results.txt

verify [ group1/a -ef group2/a ]
verify [ ! group1/a -ef group2/subdir/a ]


reset_teststate

mkdir -p ${datadir}/{group1,group2/subdir}
echo this is the testcontent > $datadir/group1/a
cp $datadir/{group1/a,group2/a}
ln $datadir/group2/{a,subdir/a}

# Run rdfind. Running with "-makehardlinks group", which will fail for old versions, falling back to old version compatible "-makehardlinks true"
$rdfind -makehardlinks true -grouphardlinks true group1 group2 > /dev/null || $rdfind -makehardlinks true group1 group2 > /dev/null

cat results.txt

verify [ group1/a -ef group2/a ]
verify [ group1/a -ef group2/subdir/a ]
