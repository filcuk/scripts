REM Drag & drop file on this script to get MD5 hash
@Echo Off
CertUtil -hashfile %1 MD5 | find /i /v "md5" | find /i /v "certutil" > "%~n1.md5"