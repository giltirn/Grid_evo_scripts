#!/bin/bash

set -e

if [[ $# == 0 ]]; then
    echo "Arguments ./acceptance.sh <log1> <log2> ..."
    exit 1
fi

for arg do
  filename=$arg
  grep "P update elapsed time" $filename | awk '{print $8,$13,"ms"}'
done
