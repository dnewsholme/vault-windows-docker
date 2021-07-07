# Vault

## About
Creates a docker image (Windows) for hashicorps [vault](https://www.vaultproject.io/).

### Setup
Build the docker image using the dockerfile.

```powershell
docker build --pull --rm -f "dockerfile" -t vault:latest "."
```

Once the image is built generate a self-signed cert for use in the container.

```powershell
.\generate-selfsignedcert.ps1
```

Then bring up the container with docker-compose.

```powershell
docker-compose up -d
```
Connect to vault on [https://localhost:8080](https://localhost:8080)

### Management

#### Certs
##### Expiration
If the cert expires, generate a new one by running `.\generate-selfsignedcert.ps1` again.
If you would like to specify SANS or commonnames other than localhost this can be done via the following command.

```powershell
.\generate-selfsignedcert.ps1 -commonname "somehost.local" -SANS "www.somehost.co.uk"
```

##### Import into windows trusted root store
Convert the cert to a der encoded .cer file for importing onto a windows host for trusted connection to the vault web address.

```powershell
push-location .\config
& openssl x509 -outform der -in vault.pem -out vault.cer
pop-location
```
Copy the vault.cer to the windows host and import into the trusted root store.
`Note: The following should be run as an administrator from windows powershell not pwsh`

If the cert is copied to a remote machine update the path on the import statement to reflect the path the file is located on the machine.
```powershell
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
$cert.import(".\config\vault.cer") 
$store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::Root,"localmachine")
$store.open("MaxAllowed") 
$store.add($cert) 
$store.close()
```

Alternatively if this is a dev environment and you will be connecting from the same machine you can run the following script to import.

```powershell
.\import-cer.ps1
```