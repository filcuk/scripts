#!/bin/bash
# Usage: remove all pdf file password
# Source: https://www.reddit.com/r/techsupport/comments/3izqfd/batch_removal_of_pdf_open_passwords/

pdfpass=YOUR_PASSWORD

shopt -s nullglob
for f in *.pdf
do
	echo "Removing password from - $f"
        qpdf --decrypt --password="$pdfpass" $f ./decrypted/$f
done