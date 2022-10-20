# purpose: remove open password from pdf files
# warning: replaces original files
# install qpdf using choco: `choco install qpdf`
$password="YOUR_PASSWORD"
Get-ChildItem -Filter *.pdf | ForEach-Object { qpfd --decrypt --replace-input --password=$password $_.name }