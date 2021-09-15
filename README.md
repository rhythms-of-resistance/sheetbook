This is the central place to manage the Rhythms of Resistance tunesheets. The website and other places link to the generated files in this repository.

The tunesheets are stored in a Git repository. Git is a version-control system that allows to put files in a shared folder, and will keep a history of all historic states (called “commits”) of the files. If you want to contribute to the tunesheet, you will have to get a GitHub account, contact the RoR Internet Working group to get write access to the repository, and then use a Git client (for example [Git Cola](https://git-cola.github.io/)) to save any changes that you make. If this is too technical for you, don’t be shy to ask the Internet Working Group for help!

When a new commit is pushed to the `develop` branch of this repository, the PDF files are generated automatically in the [`generated` folder on the `master` branch](https://github.com/rhythms-of-resistance/sheetbook/tree/master/generated) (using a GitHub Action).

A single A4 sheet is generated for each tune, and an A4, A5 and A6 booklet is provided. Not every tune is added to the booklet, some tunes are only available as single sheets.


# File structure

[`front.svg`](./front.svg) and [`back.svg`](./back.svg) contain the front and back cover. The `[month]` placeholder is automatically filled with the current month+year and the `[version]` placeholder with the short commit ID.

[`network.odt`](./network.odt) is the description of the RoR network, principles, history and RoR Player.

The ODS files contain the tune and dance sheets.


# Add a new tune

To add a new tune, simply copy one of the existing ODS files (ideally one that already has the right orientation and number of pages), edit its contents and give it a suitable name. Adding an ODS file will automatically export it as a PDF file (with the same filename) in the `generated/single` folder.

If you want the new tune to also appear in the new tunesheet booklet, you need to edit the [`make-sheets.sh`](./make-sheets.sh) script. Modifying the composition of pages in the booklet can be a complex task because the following requirements have to be met:

* The number of pages has to be dividable by 2 for the A4 booklet and by 4 for the A5/A6 booklet. Blank pages can be added to achieve this.
* The tunes are ordered alphabetically. However, some tunes need to be placed out of order so that double-page tunes appear together in the booklet, meaning that their first page should be on an even page. This means that if you add a single-page tune, you will probably have to rearrange all tunes that come after it in the booklet.

Feel free to ask the Internet Working Group for help.


# Styling guidelines

All pages are formatted as A6 (and only scaled up to A4/A5 during the PDF generation). Tunes can be a single or double page, landscape or portrait. The number/orientation of pages can be defined by selecting one of the Page Styles that are present in the ODS files.

## Tune name

18pt Arial bold, underlined by 2.5pt black double-line

## Tune sign

Right of tune name. 12pt Arial.

## Groove

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

## Breaks

* Break name: 10pt bold
* Break sign underneath break name, 9pt Arial italic
* Strokes same style as in Groove, but whole break surrounded by 0.75pt black border.
* Any explanation right of break or underneath (right-aligned), 9pt Arial
* No free lines


# Manual PDF generation

## Using docker

This is the most reliable way, as no dependencies/fonts (except docker) have to be installed.

```bash
docker run --rm -v "$PWD:/home/ror/sheetbook" rhythmsofresistance/sheetbook-build
```

## Using script

Make sure to have the [BTNGrilledCheese](./BTNGrilledCheese.zip) and Liberation Sans fonts and LibreOffice, Inkscape, qpdf and pdfjam installed.

Then run `./make-sheets.sh`.
