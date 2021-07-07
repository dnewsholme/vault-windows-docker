push-location .\config
& openssl x509 -outform der -in vault.pem -out vault.cer
pop-location
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
$cert.import(".\config\vault.cer") 
$store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::Root,"localmachine")
$store.open("MaxAllowed") 
$store.add($cert) 
$store.close()