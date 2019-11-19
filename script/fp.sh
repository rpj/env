#!/bin/bash
HF=$1
if [ -z $HF ]; then
  HF='sha256'
fi
export FP_HASH_FUNC="$HF"
find . -path '*.pub' | xargs -t -I{} -- ssh-keygen -l -E "$FP_HASH_FUNC" -f {}
