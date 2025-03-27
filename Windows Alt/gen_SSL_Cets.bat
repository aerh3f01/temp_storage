@echo off
REM =========================================================================
REM  Flask SSL Certificate Generator (.bat)
REM  - Generates a self-signed certificate for localhost
REM  - Requires OpenSSL to be installed and in PATH
REM =========================================================================

SET CERT_FOLDER=certs
SET PFX_FILE=%CERT_FOLDER%\localhost.pfx
SET PEM_FILE=%CERT_FOLDER%\cert_and_key.pem
SET CERT_PEM=%CERT_FOLDER%\cert.pem
SET KEY_PEM=%CERT_FOLDER%\key.pem
SET PASSWORD=flaskpass

REM Create certs folder
if not exist %CERT_FOLDER% (
    mkdir %CERT_FOLDER%
)

REM Step 1: Run PowerShell to generate self-signed cert and export .pfx
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$cert = New-SelfSignedCertificate -DnsName 'localhost' -CertStoreLocation 'Cert:\LocalMachine\My' -KeyExportPolicy Exportable -FriendlyName 'Flask Local SSL';" ^
    "$password = ConvertTo-SecureString -String '%PASSWORD%' -Force -AsPlainText;" ^
    "Export-PfxCertificate -Cert $cert -FilePath '%PFX_FILE%' -Password $password;"

IF NOT EXIST %PFX_FILE% (
    echo Failed to export PFX certificate. Aborting.
    exit /b 1
)

REM Step 2: Use OpenSSL to convert .pfx to .pem (with key and cert combined)
openssl pkcs12 -in "%PFX_FILE%" -out "%PEM_FILE%" -nodes -passin pass:%PASSWORD%

REM Step 3: Extract private key
openssl pkey -in "%PEM_FILE%" -out "%KEY_PEM%"

REM Step 4: Extract public certificate
openssl crl2pkcs7 -nocrl -certfile "%PEM_FILE%" | openssl pkcs7 -print_certs -out "%CERT_PEM%"

echo.
echo Certificate generation complete!
echo Files generated in: %CERT_FOLDER%
echo - %CERT_PEM%
echo - %KEY_PEM%
echo - %PFX_FILE%
echo.

pause
