#!/bin/bash

datadir="/input_data"
files=$datadir/*.mzML
outfiles=""

for f in $files
do
  bn=$(basename $f)
  fn="${bn%.*}"

  featfn=${fn}_features_rta.featureXML
  redfn=${fn}_features_rta_redetected_overlap_rm.featureXML
  outfn=${fn}_features_rta_final.featureXML

  FileMerger -in $featfn $redfn -out $outfn -annotate_file_origin
done
