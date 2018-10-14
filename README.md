This is the central place to manage the Rhythms of Resistance tunesheets. The website and other places link to the generated files in this repository.

[`front.svg`](./front.svg) and [`back.svg`](./back.svg) contain the front and back cover. When making changes to them, also update the exported PDF files `front.pdf` and `back.pdf`. Make sure to have the [BTNGrilledCheese](./BTNGrilledCheese.zip) font installed.

[`network.odt`](./network.odt) is the description of the RoR network, principles, history and RoR Player.

[`tunes.ods`](./tunes.ods) contains the tune and dance sheets.

After making changes, follow these steps:

1. Make sure to have the [BTNGrilledCheese](./BTNGrilledCheese.zip) font installed, then update the month/year in `front.svg` and regenerate `front.pdf`.
2. If you added new pages to the tunesheet or moved pages around, make sure to update the page numbers in the [`make-sheets.sh`](./make-sheets.sh) script.
3. Make sure you have LibreOffice, ImageMagick, pdftk, pdfjam and pdfnup installed
4. Run `./make-sheets.sh`
5. Commit your changes (including the generated files)
