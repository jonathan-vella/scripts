#Connect ARC Linux machines to Azure at scale
# To execute "curl -s -L https://raw.githubusercontent.com/jonathan-vella/scripts/master/linux/azure_arc_linux_install.sh | bash"
#!/bin/bash

sudo apt-get update

# <--- Change the following environment variables according to your Azure Service Principle name --->

echo "Exporting environment variables"
export subscriptionId='<>'
export appId='<>'
export password='<>'
export tenantId='<>'
export resourceGroup='ilc-arcdemo-rg'
export location='West Europe'

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
