getrawtractdata:
	# visit https://navigator.blm.gov/data?keyword=ae0092d194729cca
	# other states http://nationalcad.org/download/PLSS-CadNSDI-Data-Set-Availability.pdf
	cd data
	wget https://navigator.blm.gov/api/share/ae0092d194729cca
	mv ae0092d194729cca CadRef_v10.zip
	cd ..

getrawcountydata:
	# get PERM and PUR from https://www.yolocounty.org/general-government/general-government-departments/agriculture-cooperative-extension/agriculture-and-weights-measures/pesticide-use-report-history
	# PERM for commodities and PUR for pesticides.
	echo "todo"
	
prep:
	# force successful error code with :
	# doesn't run on its own successfully for some reasons
	R CMD BATCH prepbasemap.R || : 
	echo "prep done"
	
prepfull:
	cd data
	unzip CadRef_v10.zip
	cd ..
	R CMD BATCH prepbasemap.R
	rm -rf data/CadRef_v10.gdb

produce:
	R CMD BATCH prepmap.R
	echo "-----------------------------------------------------------------------"
	echo "this shell kludge because I couldn't figure out how to parse kml in python in a way that is editable and jsonlike"
	echo "the need is to get rid of nesting in folder, remove piecewise styling, and add css-style global styling"
	mkdir -p tmp
	head -3 data/yoloAgWSpray.kml > tmp/p1
	tail +4 data/yoloAgWSpray.kml | grep -ve "<.\?Folder>" > tmp/yoloAgWSpray.kmlp
	sed -e "s/<Style>.*<\/Style>/<styleUrl>#poly<\/styleUrl>/" tmp/yoloAgWSpray.kmlp > tmp/yoloAgWSpray2.kmlp
	cat tmp/p1 styleSnip.kmlp tmp/yoloAgWSpray2.kmlp > tmp/out.kml
	mv tmp/out.kml data/yoloAgWSpray.kml
	rm -rf tmp
	echo "-----------------------------------------------------------------------"
	zip data/yoloAgWSpray.kmz data/yoloAgWSpray.kml

ship:
	scp data/yoloAgWSpray.kmz sethfrey@enfascination.com:~/webapps/lookaroundyou/data/yoloagwspray.kmz

produce_comm_only:
	R CMD BATCH prepagmap.R
	echo "-----------------------------------------------------------------------"
	echo "this shell kludge because I couldn't figure out how to parse kml in python in a way that is editable and jsonlike"
	echo "the need is to get rid of nesting in folder, remove piecewise styling, and add css-style global styling"
	mkdir -p tmp
	head -3 data/countyDisplay.kml > tmp/p1
	tail +4 data/countyDisplay.kml | grep -ve "<.\?Folder>" > tmp/countyDisplay.kmlp
	sed -e "s/<Style>.*<\/Style>/<styleUrl>#poly<\/styleUrl>/" tmp/countyDisplay.kmlp > tmp/countyDisplay2.kmlp
	cat tmp/p1 styleSnip.kmlp tmp/countyDisplay2.kmlp > tmp/out.kml
	mv tmp/out.kml data/countyDisplay.kml
	rm -rf tmp
	echo "-----------------------------------------------------------------------"
	zip data/countyDisplay.kmz data/countyDisplay.kml

produce_spray_only:
	R CMD BATCH prepspraymap.R || : 
	echo "-----------------------------------------------------------------------"
	echo "this shell kludge because I couldn't figure out how to parse kml in python in a way that is editable and jsonlike"
	echo "the need is to get rid of nesting in folder, remove piecewise styling, and add css-style global styling"
	mkdir -p tmp
	head -3 data/countyDispray.kml > tmp/p1
	tail +4 data/countyDispray.kml | grep -ve "<.\?Folder>" > tmp/countyDispray.kmlp
	sed -e "s/<Style>.*<\/Style>/<styleUrl>#poly<\/styleUrl>/" tmp/countyDispray.kmlp > tmp/countyDispray2.kmlp
	cat tmp/p1 styleSnip.kmlp tmp/countyDispray2.kmlp > tmp/out.kml
	mv tmp/out.kml data/countyDispray.kml
	rm -rf tmp
	echo "-----------------------------------------------------------------------"
	zip data/countyDispray.kmz data/countyDispray.kml
