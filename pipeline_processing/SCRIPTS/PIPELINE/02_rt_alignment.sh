#!/bin/bash

datadir="/input_data"
files=$datadir/*.mzML
featfiles=""
rtaoutfiles=""
trafooutfiles=""

for f in $files
do
  bn=$(basename $f)
  fn="${bn%.*}"

  featfn=${fn}_features.featureXML
  rtafn=${fn}_features_rta.featureXML
  trafofn=${fn}_rta.trafoXML

  featfiles="$featfiles $featfn"
  rtaoutfiles="$rtaoutfiles $rtafn"
  trafooutfiles="$trafooutfiles $trafofn"
done

echo "Performing RT Alignment..."
MapAlignerPoseClustering -ini INI/map_aligner_pose_clustering.ini \
  -in $featfiles \
  -out $rtaoutfiles \
  -trafo_out $trafooutfiles


echo "Transforming maps..."
for f in $files
do
  bn=$(basename $f)
  fn="${bn%.*}"
  centfn=${fn}_centroided.mzML
  trafofn=${fn}_rta.trafoXML
  rtafn=${fn}_centroided_rta.mzML

  MapRTTransformer -ini INI/map_rt_transformer.ini \
    -in $centfn \
    -trafo_in $trafofn \
    -out $rtafn
done