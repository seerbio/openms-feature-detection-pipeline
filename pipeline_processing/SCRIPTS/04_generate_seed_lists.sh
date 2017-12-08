#!/bin/bash

datadir="/input_data"
files=$datadir/*.mzML
outfiles=""

for f in $files
do
  bn=$(basename $f)
  fn="${bn%.*}"

  outfn=${fn}_seed_list.featureXML
  outfiles="$outfiles $outfn"
done

SeedListGenerator -in linked_features.consensusXML -out $outfiles
