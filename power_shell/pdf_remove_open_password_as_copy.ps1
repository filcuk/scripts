# purpose: remove open password from pdf files and save as a copy
# install qpdf using choco: `choco install qpdf`
$password="YOUR_PASSWORD"
Get-ChildItem -Filter *.pdf | ForEach-Object { qpfd --decrypt --password=$password $_.name ($_.BaseName + "_copy" + $_.Extension)}