#!/bin/bash
sudo tail -n 1000 -f /var/log/auth.log | egrep "(Invalid user|Connection closed|Did not receive identification string)"
