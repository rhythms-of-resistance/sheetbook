#!/bin/bash

set -e


# Check for missing programs

missing=()
for i in qpdf pdfjam inkscape; do
	if ! which "$i" >/dev/null 2>&1; then
		missing+=("$i")
	fi
done

if ! which localc lowriter >/dev/null 2>&1; then
	missing+=("LibreOffice")
fi

if [ "${#missing[@]}" -gt 0 ]; then
	echo "Please install the following programs: ${missing[@]}"
	exit 1
fi


# Check for missing files

missing=()
for i in front.svg back.svg network.odt; do
	if [ ! -f "$i" ]; then
		missing+=("$i")
	fi
done

if [ "${#missing[@]}" -gt 0 ]; then
	echo "Missing the following files in the current directory: ${missing[@]}"
	exit 1
fi


# Clear previous generated files
mkdir -p generated
cd generated
rm -rf *
mkdir -p tmp/single tmp/single-rotated
cd tmp


# Put current month in
month="$(date '+%B %Y')"
version="$(git log --pretty=format:'%h' -n 1)"
cat ../../front.svg | sed -re "s/\[month]/$month/g" | sed -re "s/\[version]/$version/g" > front.svg
cat ../../back.svg | sed -re "s/\[month]/$month/g" | sed -re "s/\[version]/$version/g" > back.svg


# Convert files to PDF
pushd single
	localc --convert-to pdf ../../../*.ods
popd
lowriter --convert-to pdf ../../network.odt
inkscape front.svg --export-filename=front.pdf --export-type=pdf
inkscape back.svg --export-filename=back.pdf --export-type=pdf

# Wait for PDFs (generation is sometimes run in background)
#for((i=0; $i<50; i++)); do
#	[ -e "tunes.pdf" -a -e "network.pdf" ] && break
#	sleep 0.1
#done

# Scale individual tune PDFs up to A4, and generate PDFs normalized to portrait orientation
pushd single
	mkdir ../../single
	for i in *.pdf; do
		if pdfinfo "$i" | grep -qF 'Page size:      419.556'; then
			# Landscape format
			pdfjam --outfile "../../single/$i" --paper a4paper --landscape "$i"
			qpdf "../../single/$i" --rotate=-90 "../single-rotated/$i"
		else
			# Portrait format
			pdfjam --outfile "../../single/$i" --paper a4paper "$i"
			cp "../../single/$i" "../single-rotated/$i"
		fi
	done
popd

pushd single-rotated
	# Assemble pages for the tunesheet booklet. The tunes should follow alphabetical order where possible, but two-page tunes can be moved so that they take up a double-page together.

	# Assemble pages for A4 tunesheet (page number has to be divisable by 2)
	qpdf --empty --pages ../front.pdf ../network.pdf breaks.pdf afoxe.pdf bhangra.pdf angela-davis.pdf cochabamba.pdf crazy-monkey.pdf custard.pdf drum-bass.pdf drunken-sailor.pdf funk.pdf hafla.pdf hedgehog.pdf karla-shnikov.pdf no-border-bossa.pdf menaiek.pdf nova-balanca.pdf orangutan.pdf ragga.pdf sambasso.pdf rope-skipping.pdf samba-reggae.pdf sheffield-samba-reggae.pdf the-sirens-of-titan.pdf tequila.pdf walc.pdf wolf.pdf van-harte-pardon.pdf voodoo.pdf xango.pdf zurav-love.pdf ../../../blank.pdf dances.pdf ../back.pdf -- ../tunesheet-2.pdf

	# Assemble pages for A5/A6 tunesheet (page number has to be divisable by 4)
	qpdf --empty --pages ../front.pdf ../network.pdf breaks.pdf afoxe.pdf bhangra.pdf angela-davis.pdf cochabamba.pdf crazy-monkey.pdf custard.pdf drum-bass.pdf drunken-sailor.pdf funk.pdf hafla.pdf hedgehog.pdf karla-shnikov.pdf no-border-bossa.pdf menaiek.pdf nova-balanca.pdf orangutan.pdf ragga.pdf sambasso.pdf rope-skipping.pdf samba-reggae.pdf sheffield-samba-reggae.pdf the-sirens-of-titan.pdf tequila.pdf walc.pdf wolf.pdf van-harte-pardon.pdf voodoo.pdf xango.pdf zurav-love.pdf ../../../blank.pdf dances.pdf ../../../blank.pdf ../../../blank.pdf ../back.pdf -- ../tunesheet-4.pdf
popd

# Generate A4 tunesheet
pdfjam --outfile ../tunesheet-a4.pdf --paper a4paper tunesheet-2.pdf

# Order pages for A6 double booklet print
# JavaScript code to generate page string (n is the number of pages in tunesheet-4.pdf): var n=52,s=[];for(let i=1;i<=n/2;i+=2){s.push(n-i+1,i,n-i+1,i,i+1,n-i,i+1,n-i);};s.join(',');
qpdf tunesheet-4.pdf --pages . 52,1,52,1,2,51,2,51,50,3,50,3,4,49,4,49,48,5,48,5,6,47,6,47,46,7,46,7,8,45,8,45,44,9,44,9,10,43,10,43,42,11,42,11,12,41,12,41,40,13,40,13,14,39,14,39,38,15,38,15,16,37,16,37,36,17,36,17,18,35,18,35,34,19,34,19,20,33,20,33,32,21,32,21,22,31,22,31,30,23,30,23,24,29,24,29,28,25,28,25,26,27,26,27 -- tunesheet-ordered-a6.pdf

# Convert the pdf to a PDF with 4 A6 pages per A4
pdfjam --outfile ../tunesheet-a6.pdf --nup 2x2 --paper a4paper --no-landscape tunesheet-ordered-a6.pdf

# Convert the pdf to a PDF with 4 A6 pages per A4
# JavaScript code to generate page string: var n=52,s=[];for(i=1;i<=n/2;i+=2){s.push(n-i+1,i,i+1,n-i);};s.join(',');
qpdf tunesheet-4.pdf --pages . 52,1,2,51,50,3,4,49,48,5,6,47,46,7,8,45,44,9,10,43,42,11,12,41,40,13,14,39,38,15,16,37,36,17,18,35,34,19,20,33,32,21,22,31,30,23,24,29,28,25,26,27 -- tunesheet-ordered-a5.pdf

# Generate A4 pages with two A5 pages per page
pdfjam --outfile ../tunesheet-a5.pdf --nup 2x1 --paper a4paper --landscape tunesheet-ordered-a5.pdf


# Remove temporary files
cd ..
rm -rf tmp


# Print result
which tput >/dev/null 2>&1 && tput=1 || true
echo
echo "========================================================="
echo
[ ! -z "$tput" ] && tput setaf 2 && tput bold
echo "Tunesheet has successfully been generated."
[ ! -z "$tput" ] && tput sgr0
