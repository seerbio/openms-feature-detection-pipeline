#!/bin/bash

files=*_features_rta_final.featureXML

FeatureLinkerUnlabeledQT -ini ../INI/feature_linker_unlabeled_qt.ini \
  -in $files \
  -out linked_features_final.consensusXML

