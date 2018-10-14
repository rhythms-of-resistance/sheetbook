#!/bin/bash

set -e


# Check for missing programs

missing=()
for i in pdftk pdfjam pdfnup; do
	if ! which "$i" >/dev/null 2>&1; then
		missing+=("$i")
	fi
done

if ! which localc lowriter >/dev/null 2>&1; then
	missing+=("LibreOffice")
fi

if ! which convert >/dev/null 2>&1; then
	missing+=("ImageMagick")
fi

if [ "${#missing[@]}" -gt 0 ]; then
	echo "Please install the following programs: ${missing[@]}"
	exit 1
fi


# Check for missing files

missing=()
for i in tunes.ods front.pdf back.pdf network.odt; do
	if [ ! -f "$i" ]; then
		missing+=("$i")
	fi
done

if [ "${#missing[@]}" -gt 0 ]; then
	echo "Missing the following files in the current directory: ${missing[@]}"
	exit 1
fi


# Clear previous generated files
cd generated
rm -rf *


# Generate blank page
convert xc:none -page A4 blank.pdf

# Convert files to PDF
localc --convert-to pdf ../tunes.ods
lowriter --convert-to pdf ../network.odt

# Wait for PDFs (generation is sometimes run in background)
for((i=0; $i<50; i++)); do
	[ -e "tunes.pdf" -a -e "network.pdf" ] && break
	sleep 0.1
done

# Rotate pages so that all are in landscape (skip “Breaks & Signs” section)
pdftk A=tunes.pdf cat A5-7 A8west A9 A10-14west A15 A16-20west A21 A22-25west A26 A27-29west A30-33 A34-35west A36 A37west A38 A39west A40-end output tunes-rotated.pdf

# Concatenate PDFs (skipping “Breaks & Signs” section from tunes.pdf)
pdftk A=../front.pdf B=network.pdf C=tunes-rotated.pdf D=../back.pdf E=blank.pdf cat A B C1-3 E C4-end D output tunesheet.pdf

# Convert to A4
pdfjam --outfile tunesheet-a4.pdf --paper a4paper tunesheet.pdf

# Order pages for A6 double booklet print
# JavaScript code to generate page string (n has to be dividable by 4): var n=48,s=[ ],m=Math.ceil(n/2);for(i=1;i<=m;i+=2){s.push(n-i+1,i,n-i+1,i,i+1,n-i,i+1,n-i);};'A'+s.join(' A');
pdftk A=tunesheet.pdf cat A48 A1 A48 A1 A2 A47 A2 A47 A46 A3 A46 A3 A4 A45 A4 A45 A44 A5 A44 A5 A6 A43 A6 A43 A42 A7 A42 A7 A8 A41 A8 A41 A40 A9 A40 A9 A10 A39 A10 A39 A38 A11 A38 A11 A12 A37 A12 A37 A36 A13 A36 A13 A14 A35 A14 A35 A34 A15 A34 A15 A16 A33 A16 A33 A32 A17 A32 A17 A18 A31 A18 A31 A30 A19 A30 A19 A20 A29 A20 A29 A28 A21 A28 A21 A22 A27 A22 A27 A26 A23 A26 A23 A24 A25 A24 A25 output tunesheet-ordered-a6.pdf

# Convert the pdf to a PDF with 4 A6 pages per A4
pdfnup --nup 2x2 --paper a4paper --no-landscape tunesheet-ordered-a6.pdf

# Convert the pdf to a PDF with 4 A6 pages per A4
# JavaScript code to generate page string: var n=48,s=[ ],m=Math.ceil(n/2);for(i=1;i<=m;i+=2){s.push(n-i+1,i,i+1,n-i);};'A'+s.join(' A');
pdftk A=tunesheet.pdf cat A48 A1 A2 A47 A46 A3 A4 A45 A44 A5 A6 A43 A42 A7 A8 A41 A40 A9 A10 A39 A38 A11 A12 A37 A36 A13 A14 A35 A34 A15 A16 A33 A32 A17 A18 A31 A30 A19 A20 A29 A28 A21 A22 A27 A26 A23 A24 A25 output tunesheet-ordered-a5.pdf

# Generate A4 pages with two A5 pages per page
pdfnup --nup 2x1 --paper a4paper tunesheet-ordered-a5.pdf


# Remove temporary files and rename output files
rm -f blank.pdf network.pdf tunes.pdf tunes-rotated.pdf tunesheet-ordered-a5.pdf tunesheet-ordered-a6.pdf
mv tunesheet-ordered-a5-nup.pdf tunesheet-a5.pdf
mv tunesheet-ordered-a6-nup.pdf tunesheet-a6.pdf


# Generate single tunes
mkdir single
pdftk A=tunesheet-a4.pdf cat A6-8 output single/breaks.pdf
pdftk A=tunesheet-a4.pdf cat A10east output single/afoxe.pdf
pdftk A=tunesheet-a4.pdf cat A11 output single/angela-davis.pdf
pdftk A=tunesheet-a4.pdf cat A12-13east output single/bhangra.pdf
pdftk A=tunesheet-a4.pdf cat A14-15east output single/crazy-monkey.pdf
pdftk A=tunesheet-a4.pdf cat A16east output single/cochabamba.pdf
pdftk A=tunesheet-a4.pdf cat A17 output single/custard.pdf
pdftk A=tunesheet-a4.pdf cat A18east output single/drum-bass.pdf
pdftk A=tunesheet-a4.pdf cat A19east output single/drunken-sailor.pdf
pdftk A=tunesheet-a4.pdf cat A20east output single/funk.pdf
pdftk A=tunesheet-a4.pdf cat A21east output single/hafla.pdf
pdftk A=tunesheet-a4.pdf cat A22east output single/hedgehog.pdf
pdftk A=tunesheet-a4.pdf cat A23 output single/karla-shnikov.pdf
pdftk A=tunesheet-a4.pdf cat A24-25east output single/menaiek.pdf
pdftk A=tunesheet-a4.pdf cat A26east output single/no-border-bossa.pdf
pdftk A=tunesheet-a4.pdf cat A27east output single/nova-balanca.pdf
pdftk A=tunesheet-a4.pdf cat A28 output single/orangutan.pdf
pdftk A=tunesheet-a4.pdf cat A29east output single/ragga.pdf
pdftk A=tunesheet-a4.pdf cat A30-31east output single/rope-skipping.pdf
pdftk A=tunesheet-a4.pdf cat A32-33 output single/samba-reggae.pdf
pdftk A=tunesheet-a4.pdf cat A34 output single/sambasso.pdf
pdftk A=tunesheet-a4.pdf cat A35 output single/sheffield-samba-reggae.pdf
pdftk A=tunesheet-a4.pdf cat A36east output single/tequila.pdf
pdftk A=tunesheet-a4.pdf cat A37east output single/walc.pdf
pdftk A=tunesheet-a4.pdf cat A38 output single/van-harte-pardon.pdf
pdftk A=tunesheet-a4.pdf cat A39east output single/voodoo.pdf
pdftk A=tunesheet-a4.pdf cat A40 output single/xango.pdf
pdftk A=tunesheet-a4.pdf cat A41east output single/zurav-love.pdf
pdftk A=tunesheet-a4.pdf cat A42-47 output single/dances.pdf

rm -f tunesheet.pdf


# Print result
which tput >/dev/null 2>&1 && tput=1 || true
echo
echo "========================================================="
echo
[ ! -z "$tput" ] && tput setaf 2 && tput bold
echo "Tunesheet has successfully been generated."
[ ! -z "$tput" ] && tput sgr0
