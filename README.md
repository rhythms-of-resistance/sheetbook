This is the central place to manage the Rhythms of Resistance tunesheets. The website and other places link to the generated files in this repository.

Automatically generated PDFs are available in the [`generated` folder on the `master` branch](https://github.com/rhythms-of-resistance/sheetbook/tree/master/generated). The [RoR Sheetbook Generator](https://sheets.rhythms-of-resistance.org/) can be used to generate PDFs with a custom selection of tunes.

# Technical overview

The tunesheets are stored in a Git repository. Git is a version-control system that allows to put files in a shared folder, and will keep a history of all historic states (called “commits”) of the files. If you want to contribute to the tunesheet, you will have to get a GitHub account, contact the RoR Internet Working group to get write access to the repository, and then use a Git client (for example [Git Cola](https://git-cola.github.io/)) to save any changes that you make. If this is too technical for you, don’t be shy to ask the Internet Working Group for help!

When a new commit is pushed to the `develop` branch of this repository, the PDF files are generated automatically in the [`generated` folder on the `master` branch](https://github.com/rhythms-of-resistance/sheetbook/tree/master/generated) (using a GitHub Action). The following PDFs are generated:
* A single-tune PDF for each available tune (in the `single` sub-directory)
* An A4, A5 and A6 booklet containing all tunes (`all`)
* An A4, A5 and A6 booklet containing all tunes except the controversial cultural appropriation tunes (`no-ca`)

The PDFs are generated using the [RoR sheetbook generator](https://github.com/rhythms-of-resistance/sheetbook-generator). This generator is also available on [sheets.rhythms-of-resistance.org](https://sheets.rhythms-of-resistance.org/), where it can be manually invoked with a custom selection of tunes.


# File structure

[`front.svg`](./front.svg) and [`back.svg`](./back.svg) contain the front and back cover. The `[month]` placeholder is automatically filled with the current month+year and the `[version]` placeholder with the short commit ID.

[`front_ca-booklet.svg`](front_ca-booklet.svg) is used as the front cover for the cultural appropriation booklet.

The various ODT files contain the text pages of the sheetbook (network description, history, ...).

The ODS files contain the tune and dance sheets.


# Add a new tune

To add a new tune, simply copy one of the existing ODS files (ideally one that already has the right orientation and number of pages), edit its contents and give it a suitable name. Adding an ODS file will automatically export it as a PDF file (with the same filename) in the `generated/single` folder and add it to the booklets.


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
