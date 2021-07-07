param(
    [string]$commonname = "localhost",
    [string[]]$SAN = ("localhost",($env:COMPUTERNAME),"$($env:computername).$($env:userdnsdomain)")
)

push-location .\config
try {
    Remove-item "vault.key","vault.pem","vault.cer" -ErrorAction stop
}
Catch{

}
$SAN = ($SAN | ForEach-Object {"DNS:$($_)"}) -join ","
$subject = "/CN=$commonname/emailAddress=admin@$commonname/C=UK/ST=none/L=none/O=questionmark/OU=Some Unit"
& c:\Program` Files\OpenSSL-Win64\bin\openssl.exe req -newkey rsa:2048 -nodes -keyout vault.key -x509 -days 365 -out vault.pem -subj $subject -addext "subjectAltName = $SAN" -addext "certificatePolicies = 1.2.3.4"
pop-location