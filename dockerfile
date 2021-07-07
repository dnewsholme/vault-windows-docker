FROM mcr.microsoft.com/windows/servercore:ltsc2019

ARG CERT_SUBJECT="/CN=localhost/O=myorg/C=CH"
ARG CERT_DAYS=365
ARG VAULT_ADDRESS="0.0.0.0:8200"
ARG VAULT_LOGLEVEL="Info"

# installation of openssl and vault through chocolatey
# creation of a self signed certificate to support at least transport encryption
# ensure you map the volumes for log, data and config to your host
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) ; \
	choco feature enable -n=allowGlobalConfirmation ; \
	choco install openssl ; \
	choco install vault ; \
	mkdir -p c:\vault ; \
	mkdir -p c:\vault\logs ; \
	mkdir -p c:\vault\config ; \
	mkdir -p c:\vault\data ; \
	cd c:\vault\config ;

EXPOSE 8200

ENTRYPOINT ["vault.exe"]

CMD ["server", "-config=c:\\vault\\config\\vault.json"]