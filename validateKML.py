#!/usr/bin/env python
"""
Validates KML against two standards.  
use: 
    python validateKML.py data/countyDisplay.kml
"""
import sys
from os import path
from pykml import parser
from pykml.parser import Schema

### create schemas
schema_ogc = Schema("ogckml22.xsd")
schema_gx = Schema("kml22gx.xsd")

### load file
print(  sys.argv )
if len( sys.argv ) > 1:
    kml_file = path.join( sys.argv[1] )
else:
    kml_file = path.join( 'westcampusedit.kml')

with open(kml_file) as f:
    doc = parser.parse(f)

# validate it against the OGC KML schema
print( schema_ogc.validate(doc) )

# validate it against the Google Extension schema
print( schema_gx.validate(doc) )
