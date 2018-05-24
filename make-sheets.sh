#!/bin/bash

set -e


# Check for missing programs

missing=()
for i in pdftk pdfjam pdfnup lowriter localc; do
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


# Convert files to PDF
localc --convert-to pdf ../tunes.ods
lowriter --convert-to pdf ../network.odt

# Wait for PDFs (generation is sometimes run in background)
for((i=0; $i<50; i++)); do
	[ -e "tunes.pdf" -a -e "network.pdf" ] && break
	sleep 0.1
done

# Concatenate PDFs (skipping “Breaks & Signs” section from tunes.pdf)
pdftk A=../front.pdf B=network.pdf C=tunes.pdf D=../back.pdf cat A B C5-end D output tunesheet.pdf

# Create a PDF file that has all the pages in landscape
pdftk A=tunesheet.pdf cat A1-7 A8west A9 A10-14west A15 A16-20west A21 A22-25west A26 A27-29west A30-33 A35west A36 A37west A38 A39west A40-end output tunesheet-rotated.pdf

# Convert to A4
pdfjam --outfile tunesheet-a4.pdf --paper a4paper tunesheet-rotated.pdf

# Order pages for A6 double booklet print
# JavaScript code to generate page string (n has to be dividable by 4): var n=44,s=[ ],m=Math.ceil(n/2);for(i=1;i<=m;i+=2){s.push(n-i+1,i,n-i+1,i,i+1,n-i,i+1,n-i);};'A'+s.join(' A');
pdftk A=tunesheet-rotated.pdf cat A44 A1 A44 A1 A2 A43 A2 A43 A42 A3 A42 A3 A4 A41 A4 A41 A40 A5 A40 A5 A6 A39 A6 A39 A38 A7 A38 A7 A8 A37 A8 A37 A36 A9 A36 A9 A10 A35 A10 A35 A34 A11 A34 A11 A12 A33 A12 A33 A32 A13 A32 A13 A14 A31 A14 A31 A30 A15 A30 A15 A16 A29 A16 A29 A28 A17 A28 A17 A18 A27 A18 A27 A26 A19 A26 A19 A20 A25 A20 A25 A24 A21 A24 A21 A22 A23 A22 A23 output tunesheet-ordered-a6.pdf

# Convert the pdf to a PDF with 4 A6 pages per A4
pdfnup --nup 2x2 --paper a4paper --no-landscape tunesheet-ordered-a6.pdf

# Convert the pdf to a PDF with 4 A6 pages per A4
# JavaScript code to generate page string: var n=44,s=[ ],m=Math.ceil(n/2);for(i=1;i<=m;i+=2){s.push(n-i+1,i,i+1,n-i);};'A'+s.join(' A');
pdftk A=tunesheet-rotated.pdf cat A44 A1 A2 A43 A42 A3 A4 A41 A40 A5 A6 A39 A38 A7 A8 A37 A36 A9 A10 A35 A34 A11 A12 A33 A32 A13 A14 A31 A30 A15 A16 A29 A28 A17 A18 A27 A26 A19 A20 A25 A24 A21 A22 A23 output tunesheet-ordered-a5.pdf

# Generate A4 pages with two A5 pages per page
pdfnup --nup 2x1 --paper a4paper tunesheet-ordered-a5.pdf


# Remove temporary files and rename output files
rm -f network.pdf tunes.pdf tunesheet-ordered-a5.pdf tunesheet-ordered-a6.pdf tunesheet-rotated.pdf
mv tunesheet-ordered-a5-nup.pdf tunesheet-a5.pdf
mv tunesheet-ordered-a6-nup.pdf tunesheet-a6.pdf


# Generate single tunes
mkdir single
pdftk A=tunesheet-a4.pdf cat A5-7 output single/breaks.pdf
pdftk A=tunesheet-a4.pdf cat A8east output single/afoxe.pdf
pdftk A=tunesheet-a4.pdf cat A9 output single/angela-davis.pdf
pdftk A=tunesheet-a4.pdf cat A10-11east output single/bhangra.pdf
pdftk A=tunesheet-a4.pdf cat A12-13east output single/crazy-monkey.pdf
pdftk A=tunesheet-a4.pdf cat A14east output single/cochabamba.pdf
pdftk A=tunesheet-a4.pdf cat A15 output single/custard.pdf
pdftk A=tunesheet-a4.pdf cat A16east output single/drum-n-base.pdf
pdftk A=tunesheet-a4.pdf cat A17east output single/drunken-sailor.pdf
pdftk A=tunesheet-a4.pdf cat A18east output single/funk.pdf
pdftk A=tunesheet-a4.pdf cat A19east output single/hafla.pdf
pdftk A=tunesheet-a4.pdf cat A20east output single/hedgehog.pdf
pdftk A=tunesheet-a4.pdf cat A21 output single/karla-shnikov.pdf
pdftk A=tunesheet-a4.pdf cat A22-23east output single/menaiek.pdf
pdftk A=tunesheet-a4.pdf cat A24east output single/no-border-bossa.pdf
pdftk A=tunesheet-a4.pdf cat A25east output single/nova-balanca.pdf
pdftk A=tunesheet-a4.pdf cat A26 output single/orangutan.pdf
pdftk A=tunesheet-a4.pdf cat A27east output single/ragga.pdf
pdftk A=tunesheet-a4.pdf cat A28-29east output single/rope-skipping.pdf
pdftk A=tunesheet-a4.pdf cat A30-31 output single/samba-reggae.pdf
pdftk A=tunesheet-a4.pdf cat A32 output single/sambasso.pdf
pdftk A=tunesheet-a4.pdf cat A33 output single/sheffield-samba-reggae.pdf
pdftk A=tunesheet.pdf    cat A34 output single/tequila.pdf
pdftk A=tunesheet-a4.pdf cat A34east output single/walc.pdf
pdftk A=tunesheet-a4.pdf cat A35 output single/van-harte-pardon.pdf
pdftk A=tunesheet-a4.pdf cat A36east output single/voodoo.pdf
pdftk A=tunesheet-a4.pdf cat A37 output single/xango.pdf
pdftk A=tunesheet-a4.pdf cat A38east output single/zurav-love.pdf
pdftk A=tunesheet-a4.pdf cat A39-43 output single/dances.pdf

rm -f tunesheet.pdf


# Print result
which tput >/dev/null 2>&1 && tput=1 || true
echo
echo "========================================================="
echo
[ ! -z "$tput" ] && tput setaf 2 && tput bold
echo "Tunesheet has successfully been generated."
[ ! -z "$tput" ] && tput sgr0
