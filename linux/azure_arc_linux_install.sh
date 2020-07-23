#Connect ARC Linux machines to Azure at scale
# To execute "curl -s -L http://bitly/10hA8iC | bash"
#!/bin/bash

sudo apt-get update

# <--- Change the following environment variables according to your Azure Service Principle name --->

echo "Exporting environment variables"
export subscriptionId='1a4dee4d-78d9-4ec1-b2d7-3c168d5c2cd3'
export appId='10b3e335-e270-410e-87bd-4a3eebce5866'
export password='e074481c-c929-44bb-88f4-62ed20f07a01'
export tenantId='72f988bf-86f1-41af-91ab-2d7cd011db47'
export resourceGroup='ilc-arcdemo-rg'
export location='Wst Europe'

# Installing Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --service-principal --username $appId --password $password --tenant $tenantId

# Download the installation package
wget https://aka.ms/azcmagent -O ~/install_linux_azcmagent.sh

# Install the hybrid agent
bash ~/install_linux_azcmagent.sh

# Run connect command
azcmagent connect \
  --service-principal-id "${appId}" \
  --service-principal-secret "${password}" \
  --resource-group "${resourceGroup}" \
  --tenant-id "${tenantId}" \
  --location "${location}" \
  --subscription-id "${subscriptionId}"
