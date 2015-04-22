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
    find $THISMOD -name '*.ko' | sed -n -e 's@\(^.*\)/_\([^/]*\)$@mv \1/_\2 \1/\2@p' | bash -x && \
    mv ${MODS}/kernel/drivers/net/wireless/ath/_ath.ko ${MODS}/kernel/drivers/net/wireless/ath/ath.ko;
}

installIt() {
    checkroot;
    removeIt;
    find $THISMOD -name '*.ko' | sed -n -e 's@\(^.*\)/\([^_/][^/]*\)$@mv \1/\2 \1/_\2@p' | bash -x;
    local regex=`echo 's@\(^.*\)/\([^/]*\)$@cp \1/\2' "${THISMOD}"'\2@'`;
    find `pwd`/ath9k/ -name '*.ko' | sed "$regex"| bash -x;
    mv ${MODS}/kernel/drivers/net/wireless/ath/ath.ko ${MODS}/kernel/drivers/net/wireless/ath/_ath.ko;
    cp ./ath.ko ${MODS}/kernel/drivers/net/wireless/ath/ath.ko;
}

buildIt() {
    make V=1 -C $MODS/build M=`pwd` modules
}

buildItWithDomain() {
    make V=1 ccflags-y=-DFORCE_DOMAIN=$1 -C $MODS/build M=`pwd` modules
}

reloadIt() {
    checkroot;
    modprobe -r ath9k_htc && \
    modprobe -r ath9k && \
    modprobe -r ath9k_common && \
    modprobe -r ath9k_hw && \
    modprobe -r ath && \
    modprobe ath && \
    modprobe ath9k_hw && \
    modprobe ath9k_common && \
    modprobe ath9k && \
    modprobe ath9k_htc
}


[ "$1" == "install" ] && installIt && exit 0;
[ "$1" == "build" ] && [ "$2" == "-d" ] && buildItWithDomain $3 && exit 0;
[ "$1" == "build" ] && [ "$2" != "-d" ] && buildIt && exit 0;
[ "$1" == "remove" ] && removeIt && exit 0;
[ "$1" == "reload" ] && reloadIt && exit 0;

echo 'Usage:'
echo '    ./do build         # Compile';
echo "    ./do build -d FR   # Compile for French reg domain, please use capital letters only";
echo '    ./do install       # Install';
echo '    ./do remove        # Uninstall';
echo '    ./do reload        # Unload and reload driver';
