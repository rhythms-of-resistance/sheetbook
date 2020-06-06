This is the central place to manage the Rhythms of Resistance tunesheets. The website and other places link to the generated files in this repository.

[`front.svg`](./front.svg) and [`back.svg`](./back.svg) contain the front and back cover. A `[month]` placeholder can be used to automatically fill in the current month+year.

[`network.odt`](./network.odt) is the description of the RoR network, principles, history and RoR Player.

[`tunes.ods`](./tunes.ods) contains the tune and dance sheets.


Update
======

If you added new pages to the tunesheet or moved pages around, make sure to update the page numbers in the [`make-sheets.sh`](./make-sheets.sh) script.

PDF files are automatically generated and published to the [master branch](https://github.com/rhythms-of-resistance/sheetbook/tree/master) when committing changes.

If you want to do a manual rebuild, follow one of the following instructions.

### Manual update using docker

This is the most reliable way, as no dependencies/fonts (except docker) have to be installed.

```bash
docker run --rm -v "$PWD:/home/ror/sheetbook" rhythmsofresistance/sheetbook-build
```

### Manual update using script

Make sure to have the [BTNGrilledCheese](./BTNGrilledCheese.zip) font and LibreOffice, Inkscape, qpdf, pdfjam and pdfnup installed.

Then run `./make-sheets.sh`.



Styling guidelines
==================

Tune name
---------

18pt Arial bold, underlined by 2.5pt black double-line

Tune sign
---------

Right of tune name. 12pt Arial.

Groove
------

* Heading "Groove" 12pt Arial bold
* Beat numbers:
    * centered, 9pt Arial
    * Bottom border: 1.75pt black
    * No borders in between beats
* Instrument names:
    * left-aligned, 9pt Arial
    * Order (and spelling): Low Surdo, Mid Surdo, High Surdo, Repinique, Snare, Tamborim, Agogô (, Shaker) (watch out for spelling of Repinique (not Repenique!) and Agogô)
    * One free line separating different instruments, Surdos are grouped together without free lines
* Bar number (number 1, 2, 3, 4 between instrument name and strokes in case the instrument line spans across multiple rows):
    * Only there when line actually spans multiple rows
    * right-aligned, 9pt Arial
* Strokes:
    * centered, 9pt Arial
    * 0.05pt #969696 vertical borders in between strokes
    * 0.75pt black vertical borders in between beats
    * 1.75pt black vertical borders in between bars
    * No horizontal lines.
* Explanations:
    * Underneath the strokes, no empty line
    * right-aligned, 9pt Arial

Breaks
------

* Break name: 10pt bold
* Break sign underneath break name, 9pt Arial italic
* Strokes same style as in Groove, but whole break surrounded by 0.75pt black border.
* Any explanation right of break or underneath (right-aligned), 9pt Arial
* No free lines
