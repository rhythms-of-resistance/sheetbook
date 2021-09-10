#!/bin/bash

set -e


# Check for missing programs

missing=()
for i in qpdf pdfjam pdfnup inkscape; do
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
for i in tunes.ods front.svg back.svg network.odt; do
	if [ ! -f "$i" ]; then
		missing+=("$i")
	fi
done

if [ "${#missing[@]}" -gt 0 ]; then
	echo "Missing the following files in the current directory: ${missing[@]}"
	exit 1
fi


# Clear previous generated files
[ ! -e generated ] && mkdir generated
cd generated
rm -rf *


# Put current month in
month="$(date '+%B %Y')"
version="$(git log --pretty=format:'%h' -n 1)"
cat ../front.svg | sed -re "s/\[month]/$month/g" | sed -re "s/\[version]/$version/g" > front.svg
cat ../back.svg | sed -re "s/\[month]/$month/g" | sed -re "s/\[version]/$version/g" > back.svg


# Convert files to PDF
localc --convert-to pdf ../tunes.ods
lowriter --convert-to pdf ../network.odt
inkscape front.svg --export-filename=front.pdf --export-type=pdf
inkscape back.svg --export-filename=back.pdf --export-type=pdf

# Wait for PDFs (generation is sometimes run in background)
for((i=0; $i<50; i++)); do
	[ -e "tunes.pdf" -a -e "network.pdf" ] && break
	sleep 0.1
done

# Rotate pages so that all are in landscape (skip “Breaks & Signs” section)
qpdf tunes.pdf --pages . 5-14,17-22,24-36,38-z -- --rotate=-90:4-6,8-10,12-16,18-21,23,25-26,30-33,35,37 tunes-rotated.pdf

# Concatenate PDFs (skipping “Breaks & Signs” section from tunes.pdf) (make sure that the page number is an even number)
qpdf --empty --pages front.pdf network.pdf tunes-rotated.pdf 1-37 ../blank.pdf tunes-rotated.pdf 38-z back.pdf -- tunesheet.pdf

# The same, but make sure that the page number is divisible by 4
qpdf --empty --pages front.pdf network.pdf tunes-rotated.pdf 1-37 ../blank.pdf tunes-rotated.pdf 38-z ../blank.pdf 1,1 back.pdf -- tunesheet-4.pdf

# Convert to A4
pdfjam --outfile tunesheet-a4.pdf --paper a4paper tunesheet.pdf

# Order pages for A6 double booklet print
# JavaScript code to generate page string (n is the number of pages in tunesheet-4.pdf): var n=52,s=[];for(let i=1;i<=n/2;i+=2){s.push(n-i+1,i,n-i+1,i,i+1,n-i,i+1,n-i);};s.join(',');
qpdf tunesheet-4.pdf --pages . 52,1,52,1,2,51,2,51,50,3,50,3,4,49,4,49,48,5,48,5,6,47,6,47,46,7,46,7,8,45,8,45,44,9,44,9,10,43,10,43,42,11,42,11,12,41,12,41,40,13,40,13,14,39,14,39,38,15,38,15,16,37,16,37,36,17,36,17,18,35,18,35,34,19,34,19,20,33,20,33,32,21,32,21,22,31,22,31,30,23,30,23,24,29,24,29,28,25,28,25,26,27,26,27 -- tunesheet-ordered-a6.pdf

# Convert the pdf to a PDF with 4 A6 pages per A4
pdfnup --nup 2x2 --paper a4paper --no-landscape tunesheet-ordered-a6.pdf

# Convert the pdf to a PDF with 4 A6 pages per A4
# JavaScript code to generate page string: var n=52,s=[];for(i=1;i<=n/2;i+=2){s.push(n-i+1,i,i+1,n-i);};s.join(',');
qpdf tunesheet-4.pdf --pages . 52,1,2,51,50,3,4,49,48,5,6,47,46,7,8,45,44,9,10,43,42,11,12,41,40,13,14,39,38,15,16,37,36,17,18,35,34,19,20,33,32,21,22,31,30,23,24,29,28,25,26,27 -- tunesheet-ordered-a5.pdf

# Generate A4 pages with two A5 pages per page
pdfnup --nup 2x1 --paper a4paper tunesheet-ordered-a5.pdf


# Rename output files
mv tunesheet-ordered-a5-nup.pdf tunesheet-a5.pdf
mv tunesheet-ordered-a6-nup.pdf tunesheet-a6.pdf


# Generate single tunes
mkdir single
qpdf tunesheet-a4.pdf --pages . 6-8 -- single/breaks.pdf
qpdf tunesheet-a4.pdf --pages . 9 -- --rotate=+90 single/afoxe.pdf
qpdf tunesheet-a4.pdf --pages . 12 -- single/angela-davis.pdf
qpdf tunesheet-a4.pdf --pages . 10-11 -- --rotate=+90 single/bhangra.pdf
qpdf tunesheet-a4.pdf --pages . 14-15 -- --rotate=+90 single/crazy-monkey.pdf
qpdf tunesheet-a4.pdf --pages . 13 -- --rotate=+90 single/cochabamba.pdf
qpdf tunesheet-a4.pdf --pages . 16 -- single/custard.pdf
qpdf tunesheet-a4.pdf --pages . 17 -- --rotate=+90 single/drum-bass.pdf
qpdf tunesheet-a4.pdf --pages . 18 -- --rotate=+90 single/drunken-sailor.pdf
qpdf tunesheet-a4.pdf --pages . 19 -- --rotate=+90 single/funk.pdf
qpdf tunesheet-a4.pdf --pages . 20 -- --rotate=+90 single/hafla.pdf
qpdf tunesheet-a4.pdf --pages . 21 -- --rotate=+90 single/hedgehog.pdf
qpdf tunesheet-a4.pdf --pages . 22 -- single/karla-shnikov.pdf
qpdf tunesheet-a4.pdf --pages . 24-25 -- --rotate=+90 single/menaiek.pdf
qpdf tunesheet-a4.pdf --pages . 23 -- --rotate=+90 single/no-border-bossa.pdf
qpdf tunesheet-a4.pdf --pages . 26 -- --rotate=+90 single/nova-balanca.pdf
qpdf tunesheet-a4.pdf --pages . 27 -- single/orangutan.pdf
qpdf tunesheet-a4.pdf --pages . 28 -- --rotate=+90 single/ragga.pdf
qpdf tunesheet-a4.pdf --pages . 30-31 -- --rotate=+90 single/rope-skipping.pdf
qpdf tunesheet-a4.pdf --pages . 32-33 -- single/samba-reggae.pdf
qpdf tunesheet-a4.pdf --pages . 29 -- single/sambasso.pdf
qpdf tunesheet-a4.pdf --pages . 34 -- single/sheffield-samba-reggae.pdf
qpdf tunesheet-a4.pdf --pages . 35 -- --rotate=+90 single/the-roof-is-on-fire.pdf
qpdf tunesheet-a4.pdf --pages . 36 -- --rotate=+90 single/tequila.pdf
qpdf tunesheet-a4.pdf --pages . 37 -- --rotate=+90 single/walc.pdf
qpdf tunesheet-a4.pdf --pages . 38 -- --rotate=+90 single/wolf.pdf
qpdf tunesheet-a4.pdf --pages . 39 -- single/van-harte-pardon.pdf
qpdf tunesheet-a4.pdf --pages . 40 -- --rotate=+90 single/voodoo.pdf
qpdf tunesheet-a4.pdf --pages . 41 -- single/xango.pdf
qpdf tunesheet-a4.pdf --pages . 42 -- --rotate=+90 single/zurav-love.pdf
qpdf tunesheet-a4.pdf --pages . 44-49 -- single/dances.pdf

qpdf tunes.pdf --pages . 15-16 -- coupe-decale.pdf
pdfjam --outfile single/coupe-decale.pdf --paper a4paper --landscape coupe-decale.pdf

qpdf tunes.pdf --pages . 23 -- jungle.pdf
pdfjam --outfile single/jungle.pdf --paper a4paper --landscape jungle.pdf

qpdf tunes.pdf --pages . 38 -- the-sirens-of-titan.pdf
pdfjam --outfile single/the-sirens-of-titan.pdf --paper a4paper --landscape the-sirens-of-titan.pdf

# Remove temporary files
rm -f network.pdf tunes.pdf tunesheet.pdf tunesheet-4.pdf tunes-rotated.pdf tunesheet-ordered-a5.pdf tunesheet-ordered-a6.pdf coupe-decale.pdf jungle.pdf the-sirens-of-titan.pdf wolf.pdf front.svg front.pdf back.svg back.pdf


# Print result
which tput >/dev/null 2>&1 && tput=1 || true
echo
echo "========================================================="
echo
[ ! -z "$tput" ] && tput setaf 2 && tput bold
echo "Tunesheet has successfully been generated."
[ ! -z "$tput" ] && tput sgr0
