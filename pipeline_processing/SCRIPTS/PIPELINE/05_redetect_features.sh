#!/bin/bash

datadir="/input_data"
files=$datadir/*.mzML


for f in $files
do
  bn=$(basename $f)
  fn="${bn%.*}"

  fnrta=${fn}_centroided_rta.mzML
  fnsl=${fn}_seed_list.featureXML
  outfn=${fn}_features_rta_redetected.featureXML
  
  FeatureFinderCentroided -ini INI/feature_finder_centroided_seed_list.ini \
    -in $fnrta \
    -seeds $fnsl \
    -out $outfn
done
