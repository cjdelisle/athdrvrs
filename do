#!/bin/bash

MODS="/lib/modules/`uname -r`";
THISMOD="${MODS}/kernel/drivers/net/wireless/ath/ath9k/"

checkroot() {
    [ "$UID" == "0" ] && return 0;
    echo 'Doing this would work better if you were root';
    exit 100;
}

removeIt() {
    checkroot;
    find $THISMOD -name '*.ko' | sed -n -e 's@\(^.*\)/_\([^/]*\)$@mv \1/_\2 \1/\2@p' | bash -x;
}

installIt() {
    checkroot;
    removeIt;
    find $THISMOD -name '*.ko' | sed -n -e 's@\(^.*\)/\([^_/][^/]*\)$@mv \1/\2 \1/_\2@p' | bash -x;
    local regex=`echo 's@\(^.*\)/\([^/]*\)$@cp \1/\2' "${THISMOD}"'\2@'`;
    find `pwd`/ath9k/ -name '*.ko' | sed "$regex"| bash -x;
}

buildIt() {
    CFLAGS=-DATH_USER_REGD=yes_i_am_a_grownup make -C $MODS/build M=`pwd` modules
}


[ "$1" == "install" ] && installIt && exit 0;
[ "$1" == "build" ] && buildIt && exit 0;
[ "$1" == "remove" ] && removeIt && exit 0;

echo 'Usage:'
echo '    ./do build';
echo '    ./do install';
echo '    ./do remove';
