#!/bin/bash

#set -e

if [[ $# == 0 ]]; then
    echo "Arguments ./acceptance.sh <log1> <log2> ..."
    exit 1
fi

accepted=0
total=0

echo "Filename Accepted Total"
for arg do
  filename=$arg
  faccepted=$(grep 'Metropolis_test.*ACCEPTED' $filename | wc -l)
  ftotal=$(grep 'Metropolis_test' $filename | wc -l)

  echo $filename $faccepted $ftotal

  ((accepted+=faccepted))
  ((total+=ftotal))
done
val=$(echo "print $accepted/$total" | perl)
echo $accepted "/" $total ":" $val

