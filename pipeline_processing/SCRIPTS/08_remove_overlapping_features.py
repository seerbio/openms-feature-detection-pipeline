#!/usr/bin/env python

import re
import os

# Redetected feature files, featureXML format
in_fns = []
# Files with the feature ID's to remove
rm_fns = []
# Output file names
out_fns = []


# Prep the file names
for i in range(1, 18 + 1):
    file_num = str(i).zfill(3)

    tmp_fn = "20171116_" + file_num + "_features_rta_redetected.featureXML"
    in_fns.append(tmp_fn)

    tmp_fn = "20171116_" + file_num + "_feature_ids_redetected_rm.csv"
    rm_fns.append(tmp_fn)

    tmp_fn = "20171116_" + file_num + "_features_rta_redetected_overlap_rm.featureXML"
    out_fns.append(tmp_fn)


for i in range(1, 17 + 1):
    file_num = str(i).zfill(3)

    tmp_fn = "20171117_" + file_num + "_features_rta_redetected.featureXML"
    in_fns.append(tmp_fn)

    tmp_fn = "20171117_" + file_num + "_feature_ids_redetected_rm.csv"
    rm_fns.append(tmp_fn)

    tmp_fn = "20171117_" + file_num + "_features_rta_redetected_overlap_rm.featureXML"
    out_fns.append(tmp_fn)


for i in range(1, 17 + 1):
    file_num = str(i).zfill(3)

    tmp_fn = "20171120_" + file_num + "_features_rta_redetected.featureXML"
    in_fns.append(tmp_fn)

    tmp_fn = "20171120_" + file_num + "_feature_ids_redetected_rm.csv"
    rm_fns.append(tmp_fn)

    tmp_fn = "20171120_" + file_num + "_features_rta_redetected_overlap_rm.featureXML"
    out_fns.append(tmp_fn)


feats_rm = []
for fn1, fn2, ofn in zip(rm_fns, in_fns, out_fns):
    # Read in the feature ID's to remove
    ifs1 = open(fn1, 'r')
    for i, line in enumerate(ifs1):

        # Skip the header line
        if i == 0:
            next

        data = line.strip().split(",")
        feats_rm.append(data[0])

    ifs1.close()

    # Now read the featureXML and remove the overlapping
    # features; writing to a temp file, will write to the
    # final file at the end
    ofs = open("tmp.out", 'w')

    n_feat = 0
    ifs2 = open(fn2, 'r')
    line = ifs2.readline()
    while line != "":
        line_orig = line
        line = line.strip()

        # Check the feature id
        if line.startswith("<feature id="):
            feat_id = re.search('id="(.+)"', line).group(1)

            # Keep reading lines until you hit the
            # </feature> line
            if feat_id in feats_rm:
                line = ifs2.readline()
                line = line.strip()

                while line != "</feature>":
                    line = ifs2.readline()
                    line = line.strip()
            else:
                n_feat += 1
                ofs.write(line_orig)
        else:
            ofs.write(line_orig)

        line = ifs2.readline()
    
    ifs2.close()
    ofs.close()

    # Now re-read the output file and update
    # the number of features line in the xml
    ifs3 = open("tmp.out", 'r')
    ofs = open(ofn, 'w')

    line = ifs3.readline()
    while line != "":
        line_orig = line
        line = line.strip()

        if line.startswith("<featureList count="):
            line_orig = re.sub(r'[0-9]+', str(n_feat), line_orig)

        ofs.write(line_orig)
        line = ifs3.readline()

    ifs3.close()
    ofs.close()
    os.system("rm tmp.out")
