This is the central place to manage the Rhythms of Resistance tunesheets. The website and other places link to the generated files in this repository.

[`front.svg`](./front.svg) and [`back.svg`](./back.svg) contain the front and back cover. When making changes to them, also update the exported PDF files `front.pdf` and `back.pdf`. Make sure to have the [BTNGrilledCheese](./BTNGrilledCheese.zip) font installed.

[`network.odt`](./network.odt) is the description of the RoR network, principles, history and RoR Player.

[`tunes.ods`](./tunes.ods) contains the tune and dance sheets.


Rebuild
=======

After making changes, follow these steps:

1. Make sure to have the [BTNGrilledCheese](./BTNGrilledCheese.zip) font installed, then update the month/year in `front.svg` and regenerate `front.pdf`.
2. If you added new pages to the tunesheet or moved pages around, make sure to update the page numbers in the [`make-sheets.sh`](./make-sheets.sh) script.
3. Make sure you have LibreOffice, pdftk, pdfjam and pdfnup installed
4. Run `./make-sheets.sh`
5. Commit your changes (including the generated files)


Styling guidelines
==================

Tune name
---------

18pt Arial bold, underligned by 2.5pt black double-line

Tune sign
---------

Right of tune name. 12pt Arial.

Groove
------

* Heading "Groove" 12pt Arial bold
* Beat numbers underlined by 1.75pt bold. No lines in between beats
* Instruments left-aligned, 9pt Arial
* Strokes centered, 9pt Arial. In between strokes 0.05pt #969696 vertical lines. In between beats 0.75pt black vertical lines. In between bars 1.75pt black vertical lines. No horizontal lines.
* One free line separating different instruments.

Breaks
------

* Break name: 10pt bold
* Break sign underneath break name, 9pt Arial italic
* Strokes same style as in Groove, but whole break surrounded by 0.75pt black vertical border.
* Any explanation right of break or underneath (right-aligned), 9pt Arial
* No free lines
