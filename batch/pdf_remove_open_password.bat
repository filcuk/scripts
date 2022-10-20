REM purpose: remove open password from pdf files
REM warning: replaces original file
REM required: qpdf
@ECHO OFF
FOR %G IN (*.pdf) DO qpdf --decrypt --password=YOUR_PASSWORD "%G" --replace-input