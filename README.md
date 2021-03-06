Yofarmo
======


This is code for a site that displays EPA-mandated data on what agricultural products are grown in each county, where they are grown (location within a mile), and what they are sprayed with.  I wrote this to map the data for Yolo County, CA, but it should be possible to get working in any US county if you can find your county's EPA compliance data. I wanted to know what was being planted (and what was being sprayed) in the fields behind my house.  That's how I learned that everything that gets planted, and everything that gets sprayed on it has to get registered with the county, per EPA regulation. Unfortunately, that was more the beginning than the end.  In many states, the system used to link this information to specific spots on a map is very hard to get information about: the information is technically public but not practically public, and nearly all vendors are commercial. But I figured it out, thanks in large part to the impressive advances made by the open-source GIS community.

This code has several parts: 
*  The data, 
*  The code for the site that displays the data, and 
*  Maintenance scripts for connecting the data to the site.


In more detail
*  The data
   *   a link to fine, raw PLSS (tract) data
   *   a .kml of partly processed tract data
   *   a mature .kml of tract data fully annotated with plant
   *   TODO: a mature .kml of tract data fully annotated with spray info
       *   TODO: links to EPA fact sheets on each chemical.
       *   TODO: nicer (any) kmz styling
       *   TODO: map county SiteID to PLSS quartersection IDs, somehow
       *   TODO: maybe merge info from, say, two walnuts shown redundantly ont he form
       *   TODO: style pesticie info to collapse, 
       *   TODO: what's up with missing data again?  all non-square tracts are being missed.
   *   spreadsheet of raw county level data on what is currently being planted
   *   spreadsheets of raw county level data on what was sprayed when, with EPA identifiers
*  An HTML file using the Google Maps API and a bit of Javascript to pull the mature .kml up.
   *   A draft local settings file for tuning for your installation
*  Maintenance scripts for connecting the data to the site.
   *   a Makefile for running each task
   *   a script for producing intermediate tract data, stripped down to area of focus ('make prepmap')
       *   TODO a script for pulling down fresh county data (`make biggov`)
   *   a script for pulling down raw tract data (big; .gdb; `make producemap`)
   *   a script for merging ag data and tract data into publishable .kml
   *   TODO: a script for updating the site metadata


To extend to other counties and states, you need to get state specific "PLSS" (or other EPA standard tract) info: 
http://nationalcad.org/download/PLSS-CadNSDI-Data-Set-Availability.pdf
This code will be easiest to extend to other CA counties, less easy for other states listed in the PDF, and hardest for other states.

Yolo county data from https://www.yolocounty.org/general-government/general-government-departments/agriculture-cooperative-extension/agriculture-and-weights-measures/pesticide-use-report-history (get the PUR)



Requirements
------------

Requires a version of pykml updated for Python 3 (such as https://github.com/recombinant/pykml)

To run the main maintenance and processing R scripts, you need to `install.packages` several packages.  You might encounter conflicts between `dplyr` and `sf`, and you might be on your own getting a workaround kludge working.

Your county's data might be in a different format, meaning that the processing scripts will need to adapt to a different format, get my Yolo maps working first.
Also change the lat and lon in the html.

find your own place to host the KML (you can use github, except only for the final product: it doesn't work for development because of their cacheing).


Notes and credit
----

If you want to extend to your county and need a hand, email moctodliamg at the same thing backwards.

I don't think pesticides or GMO's or whatever are pure evil.  I think information wants to be free. I like knowing what grows around me.  I like making little sites.  R's `sf` is super impressive.

For more by me, visit (enfascination.com)[https://enfascination.com]
