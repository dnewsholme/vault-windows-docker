push-location .\config
try {
    Remove-item "vault.key","vault.pem" -ErrorAction stop
}
Catch{

}
& c:\Program` Files\OpenSSL-Win64\bin\openssl.exe req -newkey rsa:2048 -nodes -keyout vault.key -x509 -days 365 -out vault.pem -subj '/CN=localhost/O=myorg/C=CH'
pop-location