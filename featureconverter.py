#
# Hack of a script to pull in an MS1 feature file as created by the Multiplierz
# algorithm and convert into a OpenMS standard featureXML format.
#
# Author: Theo
#

import pandas as pd
import xml.etree.ElementTree as ET
from lxml import etree

INPUTFILE = '/Users/theoplatt/openms/P33_D2_MSB35940A.raw.ms1features.csv'
OUTPUTFILE = 'filename.featureXML'

df = pd.read_csv(INPUTFILE)


featureMap = ET.Element("featureMap")
featureList = ET.SubElement(featureMap, "featureList", count=str(len(df.index)))


tree = ET.ElementTree(featureMap)


featureindex = 0
for index, row in df.iterrows():
    feature = ET.SubElement(featureList, "feature", id="f_" + str(featureindex))

    starttimeseconds = row['startscantimemins'] * 60
    endtimeseconds = row['endscantimemins'] * 60
    charge = int(row['charge'])
    mz = row['mz']
    mzmax = mz + (4 / charge)

    ET.SubElement(feature, "position", dim="0").text = str(starttimeseconds)
    ET.SubElement(feature, "position", dim="1").text = str(mz)
    ET.SubElement(feature, "intensity").text = str(row['totalIntensity'])
    ET.SubElement(feature, "charge").text = str(charge)

    convexhull0 = ET.SubElement(feature, "convexhull", nr="0")
    ET.SubElement(convexhull0, "pt", x=str(starttimeseconds), y=str(mz))
    ET.SubElement(convexhull0, "pt", x=str(endtimeseconds), y=str(mz))

    convexhull1 = ET.SubElement(feature, "convexhull", nr="1")
    ET.SubElement(convexhull1, "pt", x=str(starttimeseconds), y=str(mzmax))
    ET.SubElement(convexhull1, "pt", x=str(endtimeseconds), y=str(mzmax))

    print(row['charge'], row['mz'], starttimeseconds, endtimeseconds)

    featureindex += 1


from xml.dom import minidom

xmlstr = minidom.parseString(ET.tostring(featureMap)).toprettyxml(indent="   ")
with open(OUTPUTFILE, "w") as f:
    f.write(xmlstr)
