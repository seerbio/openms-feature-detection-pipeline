#!/bin/bash

datadir="/input_data"
files=$datadir/*.mzML

# Construct the output file names
for f in $files
do
  bn=$(basename $f)
  fn="${bn%.*}"

  fltr_fn=${fn}_filtered.mzML
  nsfltr_fn=${fn}_gauss.mzML
  pphr_fn=${fn}_centroided.mzML
  ffc_fn=${fn}_features.featureXML

  echo "Processing $fn"

  echo "  filtering..."
  FileFilter -ini INI/file_filter.ini \
    -in $f \
    -out $fltr_fn

  echo "  Gaussian smoothing..."
  NoiseFilterGaussian -ini INI/noise_filter_gaussian.ini \
    -in $fltr_fn \
    -out $nsfltr_fn
  
  echo "  picking peaks..."
  PeakPickerHiRes -ini INI/peak_picker_hires.ini \
    -in $nsfltr_fn \
    -out $pphr_fn
  
  echo "  finding features..."
  FeatureFinderCentroided -ini INI/feature_finder_centroided.ini \
    -in $pphr_fn \
    -out $ffc_fn
done

