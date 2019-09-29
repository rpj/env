#!/bin/bash

URL='https://rules.emergingthreats.net/blockrules/compromised-ips.txt'
NEW='/home/pi/.env/script/.nc'
OLD='/home/pi/.env/script/comp-ips'
RL='/home/pi/.env/script/.runlist'

log() {
  echo "<<$0 - $(date)>> $1"
}

wget -o /dev/null -S -O $NEW $URL

if [ -e $OLD ]; then
  if [ $NEW -nt $OLD ]; then
    log "List has been updated!"
    log "Old file:"
    ls -alF $OLD
    log "New file:"
    ls -alF $NEW
    diff -u $OLD $NEW | perl -ne 'print "$1\n", if (/^\+([^+]\d*\.\d*\.\d*\.\d*)/);' > $RL
  fi
else
  log "Have never updated, using full list."
  cat $NEW > $RL
fi

if [ -e $RL ]; then
  log "Have $(wc -l $RL | awk '{ print $1 }') IPs to block..."
  cat $RL | xargs -I{} /home/pi/.env/script/block.sh {}
  log "New tables:"
  sudo iptables -S
  rm $RL
fi

mv $NEW $OLD
log "Done!"
