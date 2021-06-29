#!/bin/bash

set -e

if [[ $# == 0 ]]; then
    echo "No arguments provided"
    exit 1
fi

accepted=0
total=0

for arg do
  filename=$arg
  faccepted=$(grep 'Metropolis_test.*ACCEPTED' $filename | wc -l)
  ftotal=$(grep 'Metropolis_test' $filename | wc -l)

  ((accepted+=faccepted))
  ((total+=ftotal))
done
val=$(echo "print $accepted/$total" | perl)
echo $accepted "/" $total ":" $val

