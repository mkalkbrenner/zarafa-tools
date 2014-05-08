#!/bin/bash

SERVICES="postfix"
PACKAGES=" "
for DEB in `ls *.deb`
do
  PACKAGE=`dpkg -f $DEB Package`
  STATUS=`dpkg -s $PACKAGE | grep Status: | cut -d ' ' -f 4`
  echo "$PACKAGE: $STATUS"
  if [ 'installed' = $STATUS ]
  then
    PACKAGES="$DEB $PACKAGES"
    if [ -e /etc/init.d/$PACKAGE ]
    then
      SERVICES="$SERVICES $PACKAGE"
    fi
  fi
done

for SERVICE in $SERVICES
do
  /etc/init.d/$SERVICE stop
  echo $SERVICE
done

dpkg $1 -i $PACKAGES

/etc/init.d/postfix start
