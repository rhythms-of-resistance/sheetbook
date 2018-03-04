This is the central place to manage the Rhythms of Resistance tunesheets. The website and other places link to the generated files in this repository.

[`front.svg`](./front.svg) and [`back.svg`](./back.svg) contain the front and back cover. When making changes to them, also update the exported PDF files `front.pdf` and `back.pdf`.

[`network.odt`](./network.odt) is the description of the RoR network, principles, history and RoR Player.

[`tunes.ods`](./tunes.ods) contains the tune and dance sheets.

After making changes, follow these steps:

1. Update the month/year in `front.svg` and regenerate `front.pdf`.
2. If you added new pages to the tunesheet or moved pages around, make sure to update the page numbers in the [`make-sheets.sh`](./make-sheets.sh) script.
3. Make sure you have LibreOffice, pdftk, pdfjam and pdfnup installed
4. Run `./make-sheets.sh`
5. Commit your changes (including the generated files)
