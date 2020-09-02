#!/bin/bash

USERNAME=$1

if [ -z "$USERNAME" ]; then
  echo "Must provide username as first parameter"
  exit 1
fi

if [ "$USERNAME" = "-a" ]; then
  USERNAME=$2
  AUTHKEYSMODE=1
fi

TMPKEYS=$(mktemp)

curl -k https://api.github.com/users/${USERNAME}/keys 2> /dev/null > ${TMPKEYS}

NUMKEYS=$(jq -r '. | length' ${TMPKEYS})
KEYEND="$(($NUMKEYS - 1))"

if [ -z $AUTHKEYSMODE ]; then
  echo -e "***** $AUTHKEYSMODE Fingerprints & keys for '${USERNAME}':\n"
fi

for i in $(seq 0 $KEYEND); do
  CURTMP=$(mktemp)
  jq -r '.['${i}'].key' ${TMPKEYS} > ${CURTMP}
  CURKEY=$(cat ${CURTMP})
  FINGERPRINT=$(ssh-keygen -l -E md5 -f ${CURTMP})
  if [ -z $AUTHKEYSMODE ]; then
    echo -e "${FINGERPRINT}\n${CURKEY}\n"
  else
    echo ${CURKEY}
  fi
  rm ${CURTMP}
done

rm ${TMPKEYS}
