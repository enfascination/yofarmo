from os import path
from pykml import parser
from pykml.parser import Schema

### create schemas
schema_ogc = Schema("ogckml22.xsd")
schema_gx = Schema("kml22gx.xsd")

### load file
kml_file = path.join( 'westcampusedit.kml')

with open(kml_file) as f:
    doc = parser.parse(f)

# validate it against the OGC KML schema
print( schema_ogc.validate(doc) )

# validate it against the Google Extension schema
print( schema_gx.validate(doc) )
