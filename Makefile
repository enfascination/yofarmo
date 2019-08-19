getrawtractdata:
	# visit https://navigator.blm.gov/data?keyword=ae0092d194729cca
	# other states http://nationalcad.org/download/PLSS-CadNSDI-Data-Set-Availability.pdf
	cd data
	wget https://navigator.blm.gov/api/share/ae0092d194729cca
	cd ..

getrawcountydata:
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
	R CMD BATCH prepdisplaymap.R
	echo "-----------------------------------------------------------------------"
	echo "this shell kludge because I couldn't figure out how to parse kml in python in a way that is editable and jsonlike"
	echo "the need is to get rid of nesting in folder, remove piecewise styling, and add css-style global styling"
	mkdir -p tmp
	head -3 data/countyDisplay.kml > tmp/p1
	tail +4 data/countyDisplay.kml | grep -ve "<.\?Folder>" > tmp/countyDisplay.kmlp
	sed -e "s/<Style>.*<\/Style>/<styleUrl>#poly<\/styleUrl>/" tmp/countyDisplay.kmlp > tmp/countyDisplay2.kmlp
	cat tmp/p1 data/styleSnip.kmlp tmp/countyDisplay2.kmlp > tmp/out.kml
	mv tmp/out.kml data/countyDisplay.kml
	rm -rf tmp
	echo "-----------------------------------------------------------------------"
	zip data/countyDisplay.kmz data/countyDisplay.kml

publish:
	scp data/countyDisplay.kmz sethfrey@enfascination.com:~/webapps/htdocs/yofarmoplss.kmz
